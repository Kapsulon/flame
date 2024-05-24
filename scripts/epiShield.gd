extends Node2D

@export var healthAdd : float = 50

func _on_area_2d_body_entered(body):
	if (body.is_in_group("player")):
		body.maxLife += healthAdd
		body.life = body.maxLife
		queue_free()
