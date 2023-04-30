extends Node2D
class_name SpecialPower

@export var duration : float = 5

var _timer : float = 0
var activated : bool = false
var weapon : Weapon = null

var player : Player = null
var player_target : Vector2 = Vector2.ZERO

func _ready():
	weapon = get_parent() as Weapon
	player = GlobalFunctions.find_object_on_condition(func(elem: Node): return elem is Player, get_tree().root)

func _process(delta):
	if !activated:
		return
	_timer += delta
	if _timer >= duration:
		_timer = 0
		end_power()
	else:
		specific_process(delta)

func end_power():
	activated = false
	weapon.can_use_power = false
	end_power_child()

func use_special_power():
	activated = true
	use_special_child()

# virtual functions
func specific_process(delta: float):
	pass

func use_special_child():
	pass

func end_power_child():
	pass
	
