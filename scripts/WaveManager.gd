class_name WaveManager
extends Node

var ENEMY_SCENE := preload("res://scenes/chamallow.tscn")
var SOFA := preload("res://scenes/sofa.tscn")
var TABLE := preload("res://scenes/table.tscn")

@export
var DELAY_BETWEEN_WAVES: float = 10.0

@export
var player: Player = null

@export
var furnitureNode: Node2D = null

@export
var MAX_ENEMY_COUNT: int = 30

var last_current: int = 0
var left: int = 0
var wave: int = 0
var time_until_new_wave: float = 0.0
var spawns: Array[Marker2D]
var furnitureSpawns: Array[Marker2D]

func _ready() -> void:
	time_until_new_wave = DELAY_BETWEEN_WAVES
	for child in get_children():
		if child is Marker2D:
			spawns.append(child)
	for child in furnitureNode.get_children():
		if child is Marker2D:
			furnitureSpawns.append(child)
	

func new_wave():
	wave += 1
	left = roundi(0.5 * (wave^2) - 0.029 * wave + 23.9)

func get_current() -> int:
	var tmp := 0
	for enemy in $enemies.get_children():
		if enemy is Chamallow:
			tmp += 1
	last_current = tmp
	return tmp

func spawn_furniture() -> void:
	var valid_spawns: Array[Marker2D] = []
	var closest: Marker2D = null
	for spawn in furnitureSpawns:
		if closest == null:
			closest = spawn
			continue
		if spawn.global_position.distance_to(player.global_position) < closest.global_position.distance_to(player.global_position):
			closest = spawn
	for spawn in furnitureSpawns:
		if closest == spawn or spawn.get_child_count() == 1:
			continue
		valid_spawns.append(spawn)
	for spawn in valid_spawns:
		var rand = randi() % 2
		if rand == 0:
			spawn.add_child(SOFA.instantiate())
		if rand == 1:
			spawn.add_child(TABLE.instantiate())

func _process(delta: float) -> void:
	if left > 0 and get_current() < MAX_ENEMY_COUNT:
		spawn_furniture()
		var valid_spawns: Array[Marker2D] = []
		var closest: Marker2D = null
		for spawn in spawns:
			if closest == null:
				closest = spawn
				continue
			if spawn.global_position.distance_to(player.global_position) < closest.global_position.distance_to(player.global_position):
				closest = spawn
		for spawn in spawns:
			if closest == spawn:
				continue
			valid_spawns.append(spawn)
		var enemy: Chamallow = ENEMY_SCENE.instantiate()
		enemy.player = player
		enemy.global_position = valid_spawns[randi() % valid_spawns.size()].global_position
		$enemies.add_child(enemy)
		left -= 1
	if left == 0 && get_current() == 0:
		if time_until_new_wave <= 0:
			new_wave()
			time_until_new_wave = DELAY_BETWEEN_WAVES
		elif left == 0:
			time_until_new_wave -= delta
