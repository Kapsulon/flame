class_name TorchSwing
extends Node2D

var swinging: bool = false

func _ready() -> void:
	$pivot/Torch.self_modulate.a = 0

func swing() -> bool:
	if swinging: return false
	swinging = true
	$pivot/Torch.self_modulate.a = 255
	$pivot/Torch/burning_slash.restart()
	$pivot/Torch/flame_particle.restart()
	$AnimationPlayer.play("swing")
	await $AnimationPlayer.animation_finished
	$pivot/Torch.self_modulate.a = 0
	swinging = false
	return true
