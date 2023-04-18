extends Area2D
class_name Knife

@export var stab_damages : float = 20
var close_fight_bodies = []

func stab():
	#animation stab played
	if close_fight_bodies.size() <= 0:
		return
		
	#le plus proche ?
	#celui dans ta direction
	# -> réduire la range (un quart de cercle) en face du player
	for body in close_fight_bodies:
		if body.has_method("handle_hit"):
			body.handle_hit(self, stab_damages)
			return

func _on_close_fight_area_body_entered(new_body):
	if self.get_parent() == new_body:
		return
	if new_body is Character:
		close_fight_bodies.append(new_body)


func _on_close_fight_area_body_exited(new_body):
	var index : int = 0
	for body in close_fight_bodies:
		if body == new_body:
			close_fight_bodies.remove_at(index)
		index += 1
