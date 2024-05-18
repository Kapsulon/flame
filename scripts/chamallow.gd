extends CharacterBody2D

var anim : AnimatedSprite2D
@export var life : float
@export var maxLife : float
var alive : bool = true

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (alive):
		changeAnim(velocity.angle())
	else:
		anim.self_modulate.a -= delta
		if (anim.self_modulate.a <= 0):
			queue_free()
