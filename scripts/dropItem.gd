extends Sprite2D

@export var _time : float = 2
@export var _speed : float = 5
var _subTime : float = 0
var _sign : float = 1

# Called when the node enters the scene tree for the first time.
func _ready():
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
    _subTime += delta
    if (_subTime < _time):
        transform.origin.y += _speed * delta * _sign
    else:
        _sign *= -1
        _subTime = 0
        
