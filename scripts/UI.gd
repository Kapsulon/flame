extends CanvasLayer

@export
var player: Player

@export
var manager: WaveManager

@onready var health_bar = $Bars/Health_bar
@onready var do_bar = $Bars/Do_bar
@onready var wave_nb = $wave_nb

func _process(delta: float) -> void:
    health_bar.ratio = player.life / player.maxLife
    do_bar.ratio = player.do / player.maxDo
    wave_nb.text = "Wave %d (%d enemies left)" % [manager.wave, manager.left + manager.last_current]
