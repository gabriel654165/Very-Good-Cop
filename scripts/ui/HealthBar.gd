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

func juice_rotation():
	var juice_tween = get_tree().create_tween().set_trans(Tween.TRANS_BOUNCE)

	juice_tween.stop()

	juice_tween.tween_property(self, "rotation", 0, 0.001)

	var test := randf_range(-0.25, 0.25)

	juice_tween.tween_property(self, "rotation", test, 0.08)
	juice_tween.tween_property(self, "rotation", 0, 0.08)
	juice_tween.play()

func juice_scale():
	var juice_tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD)

	juice_tween.stop()

	juice_tween.tween_property(self, "scale", Vector2(1,1), 0.001)

	var test := Vector2(1.3, 1.3)

	juice_tween.tween_property(self, "scale", test, 0.08)
	juice_tween.tween_property(self, "scale", Vector2(1,1), 0.08)
	juice_tween.play()

func update_health_value(amount: float):
	var line_tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)

	juice_rotation()
	juice_scale()

	if amount < 0:
		line_tween.tween_property(heal_under, "value", heal_over.value, 0.5)
		heal_over.value += amount
	else:
		var aim_value = heal_over.value + amount
		line_tween.tween_property(heal_over, "value", aim_value, 0.5)

func update_max_health_value(max_health: float):
	heal_over.max_value = max_health
