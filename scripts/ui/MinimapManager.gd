extends Node2D
class_name MinimapManager

@export var display_full_map : bool = false

@export var minimap_gui : Control
@export var canvas_room_scene : PackedScene
@export var panel_container : PanelContainer
@export var rooms_grid_container : GridContainer
@export var background_material_color : Color = Color(0.75, 0.75, 0.75, 0.75)
@export var room_material_color : Color = Color(1.0, 1.0, 1.0, 0.5)
@export var player_material_color : Color = Color(0.0, 0.0, 0.0, 0.5)
@export var enemy_material_color : Color = Color(0.0, 0.0, 0.0, 0.5)
@export var powerup_material_color : Color = Color(0.0, 0.0, 0.0, 0.5)
@export var animation_player : AnimationPlayer
@export var player_marker_scene : PackedScene
@export var enemy_marker_scene : PackedScene
@export var powerup_marker_scene : PackedScene
@export var markers_scale : float = 1
@export var markers_minimum_scale : float = 0.05
@export var left_items_container : Container
@export var left_enemies_label : Label
@export var left_powerups_label : Label
@export var view_label_container : Container
@export var view_label : Label

var minimap_inst : Minimap
var active : bool
var container_width : int = 10
var container_heigth : int = 10
var is_fullscreen : bool = false
var view_by_room : bool = false
var size_room_y
var size_room_x
var offset_x : int
var offset_y : int
var player_marker : Sprite2D
var canvas_room_array : Array[CanvasItem]
var heigth_lvl : int = 9
var width_lvl : int = 9


func set_active(state: bool):
	if minimap_gui == null || minimap_inst == null:
		return
	active = state
	if active:
		generate_ui()
	else:
		unload_ui()


func set_material_shader(material: Material, parameter_name: String, new_value) -> Material:
	var shader_value : Variant = material.get_shader_parameter(parameter_name)
	var new_material : ShaderMaterial = material.duplicate()
	
	shader_value = new_value
	new_material.set_shader_parameter(parameter_name, shader_value)
	return new_material

func world_to_grid_position(world_position: Vector2) -> Vector2:
	var grid_position : Vector2 = Vector2.ZERO
	var current_room_pos : Vector2 = minimap_inst.get_current_room_pos()
	var grid_scale : Vector2 = Vector2.ZERO

	if view_by_room:
		grid_scale = Vector2(world_position.x - current_room_pos.x, world_position.y - current_room_pos.y)
	else:
		grid_scale = Vector2(world_position.x - offset_x, world_position.y - offset_y)
	grid_position = grid_scale * Vector2(size_room_x, size_room_y)
	grid_position.x += size_room_x / 2
	grid_position.y += size_room_y / 2
	return grid_position

func get_marker_scale() -> Vector2:
	var scale_factor : Vector2 = (rooms_grid_container.size / 10000)
	if scale_factor < Vector2(markers_minimum_scale, markers_minimum_scale):
		scale_factor = Vector2(markers_minimum_scale, markers_minimum_scale)
	return scale_factor

func unload_grid_childs(obj_name: String):
	for child in rooms_grid_container.get_children():
		if child.name.contains(obj_name):
			child.queue_free()

func load_markers(marker_scene, marker_list_pos, scale, material_color):
	for marker_pos in marker_list_pos:
		var marker = marker_scene.instantiate()
		rooms_grid_container.add_child(marker)
		marker.position = world_to_grid_position(marker_pos)
		marker.scale = scale
		marker.material = set_material_shader(marker.material, "color", Vector4(material_color.r, material_color.g, material_color.b, material_color.a))


func _process(delta):
	if !active:
		return
	
	size_room_x = rooms_grid_container.size.x / width_lvl
	size_room_y = rooms_grid_container.size.y / heigth_lvl
	var markers_scale = get_marker_scale()
	
	player_marker.position = world_to_grid_position(minimap_inst.get_player_pos())
	player_marker.scale = markers_scale
	player_marker.material = set_material_shader(player_marker.material, "color", Vector4(player_material_color.r, player_material_color.g, player_material_color.b, player_material_color.a))
	
	var enemy_pos_list = minimap_inst.get_room_enemies_pos_list()
	var powerup_pos_list = minimap_inst.get_room_powerups_pos_list()
	
	unload_grid_childs("MinimapPowerupMarker")
	load_markers(powerup_marker_scene, powerup_pos_list, markers_scale, powerup_material_color)
	unload_grid_childs("MinimapEnemyMarker")
	load_markers(enemy_marker_scene, enemy_pos_list, markers_scale, enemy_material_color)

	for canvas_room in canvas_room_array:
		canvas_room.material = set_material_shader(canvas_room.material, "color", Vector4(room_material_color.r, room_material_color.g, room_material_color.b, room_material_color.a))
	panel_container.material = set_material_shader(panel_container.material, "color", Vector4(background_material_color.r, background_material_color.g, background_material_color.b, background_material_color.a))
	
	update_ui_left_items_labels()


func instantiate_canvas_room(is_room: bool) -> CanvasItem:
	var canvas_room_inst : CanvasItem = canvas_room_scene.instantiate()
	rooms_grid_container.add_child(canvas_room_inst)
	if is_room:
		canvas_room_inst.material = set_material_shader(canvas_room_inst.material, "color",\
			Vector4(room_material_color.r, room_material_color.g, room_material_color.b, room_material_color.a))
	else:
		canvas_room_inst.material = set_material_shader(canvas_room_inst.material, "color", Vector4(0.0, 0.0, 0.0, 0.0))
	return canvas_room_inst


func load_rooms():
	var map : Array = minimap_inst.map if !display_full_map else minimap_inst.full_map
	
	offset_x =  minimap_inst.get_first_room_index_x()
	offset_y =  minimap_inst.get_first_room_index_y()
	heigth_lvl = minimap_inst.get_heigth() if !view_by_room else 1
	width_lvl = minimap_inst.get_width() if !view_by_room else 1
	rooms_grid_container.columns = width_lvl
	canvas_room_array.clear()
	for idx_h in heigth_lvl:
		for idx_w in width_lvl:
			var is_room = map[idx_h+offset_y][idx_w+offset_x] or view_by_room
			var canvas_room = instantiate_canvas_room(is_room)
			if is_room:
				canvas_room_array.append(canvas_room)


func generate_ui():
	minimap_gui.visible = true
	unload_grid_childs("MinimapPlayerMarker")
	player_marker = player_marker_scene.instantiate()
	rooms_grid_container.add_child(player_marker)
	unload_grid_childs("MinimapRoomItem")
	load_rooms()
	update_ui_view_label()


func unload_ui():
	minimap_gui.visible = false
	for child in rooms_grid_container.get_children():
		child.queue_free()


func update():
	unload_grid_childs("MinimapRoomItem")
	load_rooms()


func update_ui_view_label():
	left_items_container.visible = false if is_fullscreen else true
	view_label_container.visible = false if is_fullscreen else true
	view_label.text = "room" if view_by_room else "level"

func update_ui_left_items_labels():
	var enemies_left = minimap_inst.get_room_enemies_pos_list().size() if view_by_room else minimap_inst.get_full_map_enemies_pos_list().size()
	var powerups_left = minimap_inst.get_room_powerups_pos_list().size() if view_by_room else minimap_inst.get_full_map_powerups_pos_list().size()
	left_enemies_label.text = str(enemies_left)
	left_powerups_label.text = str(powerups_left)


func handle_minimap_power_up(enable: bool):
	display_full_map = enable
	update()


func _unhandled_input(event):
	if event.is_action_pressed("fullscreen_minimap"):
		if animation_player.is_playing() and animation_player.current_animation == "full_screen_minimap" or is_fullscreen:
			animation_player.play("full_screen_minimap", -1, -1.0, true)
			is_fullscreen = false
		else:
			animation_player.play("full_screen_minimap", -1, 1.0, false)
			is_fullscreen = true
		update_ui_view_label()
	
	if event.is_action_pressed("switch_minimap_view"):
		view_by_room = !view_by_room
		unload_grid_childs("MinimapRoomItem")
		load_rooms()
		update_ui_view_label()
