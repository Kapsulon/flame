@tool
class_name Player
extends CharacterBody2D

var cam := Camera2D.new()
var sprite := Sprite2D.new()
var collision := CollisionShape2D.new()

@export
var SPEED = 400

@export
var collision_shape: Shape2D:
    set(n_collision_shape):
        collision_shape = n_collision_shape
        collision.shape = n_collision_shape

@export
var sprite_path: CompressedTexture2D:
    set(n_sprite_path):
        sprite_path = n_sprite_path
        sprite.texture = n_sprite_path

func _init() -> void:
    collision.shape = RectangleShape2D.new()

func _ready() -> void:
    add_child(cam)
    add_child(sprite)
    add_child(collision)

func _process(_delta: float) -> void:
    cam.position = get_local_mouse_position() / 16

func _physics_process(_delta: float) -> void:
    var dir := Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
    velocity = dir.normalized() * SPEED
    move_and_slide()
