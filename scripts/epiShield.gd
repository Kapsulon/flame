extends Node2D

@export var healthAdd : float = 10

func _on_area_2d_body_entered(body):
    if (body.is_in_group("player")):
        var player : Player = body.get_parent()
        player.maxLife += healthAdd
        player.life = player.maxLife
