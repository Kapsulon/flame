extends Node2D

@export var fireRateAdd : float = 1

func _on_area_2d_body_entered(body):
	if (body.is_in_group("player")):
		var player : Player = body.get_parent()
		player.fireRate += fireRateAdd
