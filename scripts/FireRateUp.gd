extends Node2D

@export var fireRateAdd : float = 0.2

func _on_area_2d_body_entered(body):
	if (body.is_in_group("player")):
		body.fireRate += fireRateAdd
		queue_free()
