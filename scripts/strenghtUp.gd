extends Node2D

@export var strenghtAdd : float = 1

func _on_area_2d_body_entered(body):
    if (body.is_in_group("player")):
        body.strenght += strenghtAdd
