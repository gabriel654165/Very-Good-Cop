extends Node2D
class_name MinimapManager

@export var minimap_gui : Control
@export var canvas_room_scene : PackedScene
@export var panel_container : PanelContainer
@export var rooms_grid_container : GridContainer
@export var room_material_color : Color = Color(1.0, 1.0, 1.0, 0.5)
@export var animation_player : AnimationPlayer
@export var player_marker : Sprite2D

var minimap_inst : Minimap
var active : bool
var container_width : int = 10
var container_heigth : int = 10
var is_zoomed : bool = false
var offset_x : int
var offset_y : int
var room_size : Vector2 = Vector2(22., 22.)

func set_active(state: bool):
	if minimap_gui == null || minimap_inst == null:
		return
	active = state
	if active:
		generate_ui()
	else:
		unload_ui()

func instantiate_canvas_room(is_room: bool):
	var canvas_room_inst : ColorRect = canvas_room_scene.instantiate()
	var shader_color : Variant = canvas_room_inst.get_material().get_shader_parameter("color")
	var new_material : ShaderMaterial = canvas_room_inst.material.duplicate()
	
	room_size = canvas_room_inst.size
	canvas_room_inst.material = new_material
	rooms_grid_container.add_child(canvas_room_inst)
	canvas_room_inst.update_minimum_size()
	if is_room:
		shader_color = Vector4(room_material_color.r, room_material_color.g, room_material_color.b, room_material_color.a)
		new_material.set_shader_parameter("color", shader_color)
	else:
		shader_color = Vector4(0.0, 0.0, 0.0, 0.0)
		new_material.set_shader_parameter("color", shader_color)


#func get_room_size() -> int:
#	var room_size : float = 22.0
#	var width_rooms_number = minimap_inst.get_width()
#	var heigth_rooms_number = minimap_inst.get_heigth()
#	if width_rooms_number > heigth_rooms_number:
#		room_size = container_width / width_rooms_number
#	else:
#		room_size = container_heigth / heigth_rooms_number
#	print("new size = ", room_size)
#	return room_size

var size_room_y
var size_room_x


func _process(delta):
	size_room_x = rooms_grid_container.size.x / minimap_inst.get_width()
	size_room_y = rooms_grid_container.size.y / minimap_inst.get_heigth()
	var grid_scale = get_viewport_rect().size / rooms_grid_container.get_rect().size
	
	var lol := Vector2(minimap_inst.get_player_pos().x - offset_x, minimap_inst.get_player_pos().y - offset_y)
	player_marker.position = lol * Vector2(size_room_x, size_room_y)
	player_marker.position.x +=  size_room_x / 2
	player_marker.position.y +=  size_room_y / 2
	
	# + rooms_grid_container.get_rect().size / 2
	#player_marker.position = (player_marker.position - minimap_inst.get_player_pos()) * grid_scale# + rooms_grid_container.get_rect().size / 2
	#player_marker.position *= -1

#	player_marker.position *= rooms_grid_container.position + rooms_grid_container.get_rect().size
	
	#player_marker.position = minimap_inst.get_player_pos()
	print("player_marker.position = ", player_marker.position)

func generate_ui():
	# SOLVE LES ROOMS PAS CARRE
	#les container margin UP & BOTTOM || RIGHT & LEFT
	# -> doivent être (nb X plus grand que il y a plus de room en X qu'en Y)
	# -> / 2 prcq y a 2 margins
	
	var map : Array = minimap_inst.get_minimap()
	var full_map : Array = minimap_inst.get_full_minimap()
	offset_x =  minimap_inst.get_first_room_index_x()
	offset_y =  minimap_inst.get_first_room_index_y()
	
	minimap_gui.visible = true
	rooms_grid_container.columns = minimap_inst.get_width()
	for idx_h in minimap_inst.get_heigth():
		for idx_w in minimap_inst.get_width():
			instantiate_canvas_room(full_map[idx_h+offset_y][idx_w+offset_x])


func unload_ui():
	minimap_gui.visible = false
	for child in rooms_grid_container.get_children():
		if child.name == "PlayerMarker":
			continue
		child.queue_free()


func update():
	for child in rooms_grid_container.get_children():
		if child.name == "PlayerMarker":
			continue
		child.queue_free()
	generate_ui()


func _unhandled_input(event):
	if event.is_action_pressed("tab"):
		if animation_player.is_playing() and animation_player.current_animation == "full_screen_minimap" or is_zoomed:
			animation_player.play("full_screen_minimap", -1, -1.0, true)
			is_zoomed = false
		else:
			animation_player.play("full_screen_minimap", -1, 1.0, false)
			is_zoomed = true
