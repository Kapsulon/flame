extends StaticBody2D

var life : float = 100
var maxLife : float = 100
var alive : bool = true
var sprite : Sprite2D

static var monster := preload("res://scenes/consumable/heal.tscn")
static var deo := preload("res://scenes/consumable/deo.tscn")
static var fireRate := preload("res://scenes/consumable/FireRateUp.tscn")
static var fireRange := preload("res://scenes/consumable/FireRangeUp.tscn")
static var strenght := preload("res://scenes/consumable/strenghtUp.tscn")
static var epiShield := preload("res://scenes/consumable/epiShield.tscn")

func burn(damage : float):
    life -= damage
    if (life <= 0):
        alive = false
    var percent : float = life / maxLife
    sprite.self_modulate = Color.SADDLE_BROWN * (1 - percent) + Color.WHITE * percent

# Called when the node enters the scene tree for the first time.
func _ready():
    sprite = get_node("Sprite2D")

func drop():
    print("hello")
    randomize()
    var value : int = randi() % 11
    var obj
    if (value <= 2):
        obj = monster.instantiate()
    elif (value <= 4):
        obj = deo.instantiate()
    elif (value <= 6):
        obj = strenght.instantiate()
    elif (value <= 8):
        obj = epiShield.instantiate()
    elif (value <= 9):
        obj = fireRate.instantiate()
    else:
        obj = fireRange.instantiate()
    obj.position = position
    get_tree().root.add_child(obj)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if (alive == false):
        sprite.self_modulate.a -= delta
        if (sprite.self_modulate.a <= 0):
            randomize()
            if (randi() % 101 <= 50):
                drop()
            queue_free()
