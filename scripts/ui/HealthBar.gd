extends Control

@onready var heal_over = $HealOver
@onready var heal_under = $HealUnder

var health_obj : Health = null

func set_health(value: float):
	heal_over.value = value
	heal_under.value = value

func set_max_health(value: float):
	heal_over.max_value = value
	heal_under.max_value = value

func update_health_value(amount: float):
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)	
	
	if amount < 0:
		tween.tween_property(heal_under, "value", heal_over.value, 0.5)
		heal_over.value += amount
	else:
		var aim_value = heal_over.value + amount
		tween.tween_property(heal_over, "value", aim_value, 0.5)

func update_max_health_value(max_health: float):
	heal_over.max_value = max_health
