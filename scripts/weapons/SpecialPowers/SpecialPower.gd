extends Node2D
class_name SpecialPower

var duration : float = 5
var _timer : float = 0
var weapon : Weapon = null
var activated : bool = false

func _ready():
	weapon = get_parent() as Weapon

func _process(delta):
	if !activated:
		return
	_timer += delta
	if _timer >= duration:
		_timer = 0
		end_power()
	else:
		specific_process(delta)

# virtual functions
func specific_process(delta: float):
	pass

func end_power():
	activated = false
	print("parent power no more active")

func use_special_power():
	activated = true
	print("use parent special power")
