class_name TorchSwing
extends Node2D

var swinging: bool = false
var damage: float = 20
@export var player : Player

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


func _on_hitbox_body_entered(body):
    if (body.is_in_group("burnable") and body.alive):
        body.burn(damage)
    if (body.is_in_group("enemy") and body.alive):
        body.hit(damage, (body.position - player.position).normalized() * 600, 0.2)
