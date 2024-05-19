extends Node

var ENEMY_SCENE := preload("res://scenes/chamallow.tscn")

@export
var DELAY_BETWEEN_WAVES: float = 10.0

@export
var player: Player = null

@export
var MAX_ENEMY_COUNT: int = 30

var left: int = 0
var wave: int = 0
var time_until_new_wave: float = 0.0
var spawns: Array[Marker2D]

func _ready() -> void:
    time_until_new_wave = DELAY_BETWEEN_WAVES
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

func get_current() -> int:
    var tmp := 0
    for enemy in $enemies.get_children():
        if enemy is Chamallow:
            tmp += 1
    return tmp

func _process(delta: float) -> void:
    if time_until_new_wave <= 0:
        new_wave()
        time_until_new_wave = DELAY_BETWEEN_WAVES
    elif left == 0:
        time_until_new_wave -= delta
    if left > 0 and get_current() < MAX_ENEMY_COUNT:
        var enemy: Chamallow = ENEMY_SCENE.instantiate()
        enemy.global_position = spawns[randi() % spawns.size()].global_position
        $enemies.add_child(enemy)
        left -= 1
