extends Node

@onready var ENEMY_SCENE := preload("res://scenes/chamallow.tscn")

@export
var DELAY_BETWEEN_WAVES: float = 10.0

@export
var player: Player = null

var left: int = 0
var current: int = 0
var wave: int = 0
var time_until_new_wave: float = 0.0
var spawns: Array[Marker2D]

func _ready() -> void:
    for child in get_children():
        if child is Marker2D:
            spawns.append(child)

func new_wave():
    var valid_spawns: Array[Marker2D] = []
    for spawn in spawns:
        if spawn.global_position.distance_to(player.global_position) > 100:
            valid_spawns.append(spawn)
    wave += 1
    left = roundi(0.09 * (wave^2) - 0.029 * wave + 23.9)
