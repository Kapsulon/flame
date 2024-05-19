extends CanvasLayer

@onready var health_bar = $Bars/Health_bar
@onready var do_bar = $Bars/Do_bar

var max_hp = 100
var max_do = 100

var hp : float = max_hp
var do : float =  max_do

func _ready():
    health_bar.max_value = max_hp
    health_bar.value = hp
    do_bar.max_value = max_hp
    do_bar.value = do

func increase_max_hp(val :float):
    max_hp += val
    hp = max_hp
    health_bar.max_value = max_hp
    health_bar.value = hp

func increase_hp(val :float):
    hp += val
    if (hp > max_hp):
        hp = max_hp
    do_bar.value = do

func decrease_hp(val :float) -> bool:
    if (hp > 0):
        hp -= val
        health_bar.value = hp
        return true
    return false

func increase_do(val :float):
    do += val
    if (do > max_do):
        do = max_do
    do_bar.value = do

func decrease_do(val :float) -> bool:
    if (do > 0):
        do -= val
        do_bar.value = do
        return true
    return false
