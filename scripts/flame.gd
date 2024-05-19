extends Node2D

@export var _dirVect : Vector2 = Vector2(0, 0)
@export var _speed : float = 1.0
@export var damage : float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready():
	setDirVect(_dirVect)

func setDirVect(vect : Vector2):
	_dirVect = vect.normalized()
	var angle = atan(_dirVect.x / _dirVect.y)
	rotate(angle)
	if (_dirVect.x < 0):
		scale.x = -scale.x

func setSpeed(speed : float):
	_speed = speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += _dirVect * _speed * delta


func _on_animated_sprite_2d_animation_finished():
    queue_free()


func _on_area_2d_body_entered(body):
    if (body.is_in_group("burnable") and body.alive):
        body.burn(damage)
    if (body.is_in_group("enemy") and body.alive):
        body.hit(damage)
