@tool
class_name Player
extends CharacterBody2D

var FLAME_PARTICLE_SCENE := preload("res://assets/particles/flame_particle.tscn")
var TORCH_SWING_SCENE := preload("res://scenes/torchswing.tscn")
var FLAME_SPRAY_SCENE := preload("res://scenes/flame.tscn")
var POINTER_SCENE := preload("res://scenes/pointer.tscn")

var UI

var controller: bool = false:
    set(n_controller):
        controller = n_controller
        pointer.visible = controller
        if controller:
            Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
        else:
            Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

var last_aim_dir := Vector2.ZERO

var cam := Camera2D.new()
var sprite := AnimatedSprite2D.new()
var collision := CollisionShape2D.new()
var pointer := POINTER_SCENE.instantiate()

var torch_sprite := Sprite2D.new()
var torch_flame := FLAME_PARTICLE_SCENE.instantiate()
var torch_swing := TORCH_SWING_SCENE.instantiate()
var torch_spray_cd: float = 0.0

@export
var SPEED: float = 400

@export
var TORCH_OFFSET: float = 32

var life : float = 100
var maxLife : float = 100
var do : float = 100
var maxDo : float = 100
var strenght : float = 20
var fireRate : float = 1
var fireRange : float = 1

@export
var SPRAY_COOLDOWN: float = 0.25

@export
var collision_shape: Shape2D:
    set(n_collision_shape):
        collision_shape = n_collision_shape
        collision.shape = n_collision_shape

@export
var torch: CompressedTexture2D:
    set(n_torch):
        torch = n_torch
        torch_sprite.texture = n_torch

@export
var animation_path: SpriteFrames:
    set(n_animation_path):
        animation_path = n_animation_path
        sprite.sprite_frames = n_animation_path

@export var animation: String:
    set(n_animation):
        animation = n_animation
        sprite.play(n_animation)

@export var animation_frame: int:
    set(n_animation_frame):
        animation_frame = n_animation_frame
        sprite.frame = n_animation_frame

func _init() -> void:
    collision.shape = RectangleShape2D.new()

func _ready() -> void:
    add_child(pointer)
    cam.process_callback = Camera2D.CAMERA2D_PROCESS_PHYSICS
    cam.position_smoothing_enabled = true
    cam.position_smoothing_speed = 16.0
    add_child(cam)
    sprite.scale *= 4
    sprite.play(animation)
    add_child(sprite)
    add_child(collision)
    torch_sprite.scale = Vector2(0.75, 0.75)
    add_child(torch_sprite)
    torch_sprite.add_child(torch_flame)
    torch_flame.position.y = -torch_sprite.get_rect().size.y / 2
    add_child(torch_swing)
    UI = get_node("../UI")

func swing(aim: Vector2) -> void:
    torch_swing.damage = strenght
    torch_sprite.hide()
    torch_flame.emitting = false
    if not controller:
        torch_swing.rotation = get_local_mouse_position().angle()
    else:
        torch_swing.rotation = aim.angle()
    await torch_swing.swing()
    torch_flame.restart()
    torch_sprite.show()

func spray(aim: Vector2) -> void:
    if torch_spray_cd > 0.0: return
    if do <= 0.0: return
    do -= 0.25 / fireRate
    torch_spray_cd = SPRAY_COOLDOWN / fireRate
    var tmp = FLAME_SPRAY_SCENE.instantiate()
    tmp.position = position
    tmp.setSpeed(512.0 * (1 + fireRange / 10))
    tmp.damage = strenght / 2
    if not controller:
        tmp.setDirVect(get_global_mouse_position() - position)
    else:
        tmp.setDirVect(aim)
    get_tree().root.add_child(tmp)

func _process(delta: float) -> void:
    if Engine.is_editor_hint(): return
    torch_spray_cd = maxf(0.0, torch_spray_cd - delta)
    if not controller:
        cam.position = get_global_mouse_position() / 16
    else:
        cam.position = Vector2.ZERO

func should_turn(aim: Vector2) -> void:
    if not controller:
        sprite.flip_h = get_global_mouse_position().x < position.x
    else:
        sprite.flip_h = aim.x < 0
        pointer.rotation = aim.angle()
    torch_sprite.position.x = -TORCH_OFFSET if sprite.flip_h else TORCH_OFFSET
    torch_sprite.rotation = deg_to_rad(-45.0) if sprite.flip_h else deg_to_rad(45.0)

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventJoypadButton or event is InputEventJoypadMotion:
        controller = true
    else:
        controller = false

func _physics_process(_delta: float) -> void:
    if Engine.is_editor_hint(): return
    var dir := Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
    var aim_dir := Vector2(Input.get_axis("aim_left", "aim_right"), Input.get_axis("aim_up", "aim_down"))
    if aim_dir == Vector2.ZERO:
        aim_dir = last_aim_dir
    else:
        last_aim_dir = aim_dir
    if Input.is_action_just_pressed("action1"):
        swing(aim_dir)
    if Input.is_action_pressed("action2"):
        spray(aim_dir)
    velocity = dir.normalized() * SPEED
    if velocity.length() > 0.0:
        var tmp = animation
        animation = "running"
        if tmp != animation:
            animation_frame = 1
    else:
        animation = "idle"
    should_turn(aim_dir)
    move_and_slide()
