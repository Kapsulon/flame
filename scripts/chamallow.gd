extends CharacterBody2D

var anim : AnimatedSprite2D
@export var life : float
@export var maxLife : float
var alive : bool = true

static var monster := preload("res://scenes/consumable/heal.tscn")
static var deo := preload("res://scenes/consumable/deo.tscn")
static var fireRate := preload("res://scenes/consumable/FireRateUp.tscn")
static var fireRange := preload("res://scenes/consumable/FireRangeUp.tscn")
static var strenght := preload("res://scenes/consumable/strenghtUp.tscn")
static var epiShield := preload("res://scenes/consumable/epiShield.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	anim = get_node("AnimatedSprite2D")

func hit(damage : float):
	life -= damage
	if (life <= 0):
		alive = false
	var percent : float = life / maxLife
	anim.self_modulate = Color.SADDLE_BROWN * (1 - percent) + Color.WHITE * percent

func changeAnim(angle : float):
	if (angle < PI / 2 and angle > -PI / 2):
		scale.x = 1
		anim.animation = "side"
	elif (angle < 3 * (PI / 2) && angle >= PI / 2):
		anim.animation = "up"
	elif (angle < -3 * (PI / 2) && angle >= -PI / 2):
		anim.animation = "down"
	else:
		scale.x = -1
		anim.animation = "side"

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
func _physics_process(delta):
	if (alive):
		changeAnim(velocity.angle())
	else:
		anim.self_modulate.a -= delta
		if (anim.self_modulate.a <= 0):
			randomize()
			if (randi() % 101 <= 10):
				drop()
			queue_free()
