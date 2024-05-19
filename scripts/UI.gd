extends CanvasLayer

@export
var player: Player

@onready var health_bar = $Bars/Health_bar
@onready var do_bar = $Bars/Do_bar

func _process(delta: float) -> void:
    health_bar.ratio = player.life / player.maxLife
    do_bar.ratio = player.do / player.maxDo
