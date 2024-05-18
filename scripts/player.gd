@tool
class_name Player
extends CharacterBody2D

var cam := Camera2D.new()
var sprite := AnimatedSprite2D.new()
var collision := CollisionShape2D.new()

@export
var SPEED = 400

@export
var collision_shape: Shape2D:
	set(n_collision_shape):
		collision_shape = n_collision_shape
		collision.shape = n_collision_shape

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
	cam.process_callback = Camera2D.CAMERA2D_PROCESS_PHYSICS
	cam.position_smoothing_enabled = true
	cam.position_smoothing_speed = 16.0
	add_child(cam)
	sprite.scale *= 4
	sprite.play(animation)
	add_child(sprite)
	add_child(collision)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	cam.position = get_local_mouse_position() / 16

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	var dir := Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	velocity = dir.normalized() * SPEED
	if velocity.length() > 0.0:
		var tmp = animation
		animation = "running"
		if tmp != animation:
			animation_frame = 1
	else:
		animation = "idle"
	sprite.flip_h = get_global_mouse_position().x < position.x
	move_and_slide()
