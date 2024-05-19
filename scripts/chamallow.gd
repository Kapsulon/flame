class_name Chamallow
extends CharacterBody2D

var anim : AnimatedSprite2D
@export var life : float
@export var maxLife : float
var alive : bool = true

var speed = randi_range(150, 500)
@export var player: Player
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

static var monster := preload("res://scenes/consumable/heal.tscn")
static var deo := preload("res://scenes/consumable/deo.tscn")
static var fireRate := preload("res://scenes/consumable/FireRateUp.tscn")
static var fireRange := preload("res://scenes/consumable/FireRangeUp.tscn")
static var strenght := preload("res://scenes/consumable/strenghtUp.tscn")
static var epiShield := preload("res://scenes/consumable/epiShield.tscn")

var knock : Vector2
var knockBackTime : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    anim = get_node("AnimatedSprite2D")

func hit(damage : float, knockBack : Vector2, knockTime : float):
    knock = knockBack
    knockBackTime = knockTime
    life -= damage
    if (life <= 0):
        alive = false
    var percent : float = life / maxLife
    anim.self_modulate = Color.SADDLE_BROWN * (1 - percent) + Color.WHITE * percent

func changeAnim(angle : float):
    if (angle < PI / 4 and angle > -PI / 4):
        $AnimatedSprite2D.flip_h = false
        anim.animation = "side"
    elif (angle < 3 * (PI / 4) && angle >= PI / 4):
        anim.animation = "down"
    elif (angle > -3 * (PI / 4) && angle <= -PI / 4):
        anim.animation = "up"
    else:
        $AnimatedSprite2D.flip_h = true
        anim.animation = "side"

func drop():
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
func _physics_process(delta : float) -> void:
    if (knockBackTime <= 0):
        if (alive):
            var dir = to_local(nav_agent.get_next_path_position()).normalized()
            velocity = dir * speed
            move_and_slide()
            changeAnim(velocity.angle())
        else:
            anim.self_modulate.a -= delta
            if (anim.self_modulate.a <= 0):
                randomize()
                if (randi() % 101 <= 10):
                    drop()
                queue_free()
    else:
        velocity = knock
        knockBackTime -= delta
        move_and_slide()

func makepath() -> void:
    nav_agent.target_position = player.global_position

func _on_timer_timeout():
    makepath()
