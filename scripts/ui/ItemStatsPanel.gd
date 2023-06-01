extends PanelContainer
class_name ItemStatsPanel

@export var properties_stats_panel : Node
@export var ammo_stats_panel : Node
@export var projectiles_stats_panel : Node
@export var powers_stats_panel : Node

@export var properties_stats_container : GridContainer
@export var ammo_stats_container : GridContainer
@export var projectiles_stats_container : GridContainer
@export var powers_stats_container : GridContainer

@export var property_stat_container_scene : PackedScene

var distance_weapon_stats_list : Array[PropertyStatContainer] = []
var melee_weapon_stats_list : Array[PropertyStatContainer] = []
var equipment_stats_list : Array[PropertyStatContainer] = []

var item_name : String = ''
var stat_upgrade_name : String = ''

func generate_ui():
	distance_weapon_stats_list = generate_stat_list(GlobalVariables.player_distance_weapon_list, GlobalVariables.all_distance_weapon_list, GlobalVariables.index_distance_weapon_selected)
	melee_weapon_stats_list = generate_stat_list(GlobalVariables.player_melee_weapon_list, GlobalVariables.all_melee_weapon_list, GlobalVariables.index_melee_weapon_selected)
	#equipment_stats_list = generate_stat_list(GlobalVariables.player_equipment_list, GlobalVariables.all_equipment_list)

func load_stat_item(ref_stat) -> PropertyStatContainer:
	var stat_item = property_stat_container_scene.instantiate()
	
	if ref_stat.type == "property":
		properties_stats_panel.visible = true
		properties_stats_container.add_child(stat_item)
	elif ref_stat.type == "ammo":
		ammo_stats_panel.visible = true
		ammo_stats_container.add_child(stat_item)
	elif ref_stat.type == "projectile":
		projectiles_stats_panel.visible = true
		projectiles_stats_container.add_child(stat_item)
	elif ref_stat.type == "power":
		powers_stats_panel.visible = true
		powers_stats_container.add_child(stat_item)
	return stat_item


func generate_stat_list(player_items_levels, ref_items_stats, equiped_item_index) -> Array[PropertyStatContainer]:
	var stat_list : Array[PropertyStatContainer] = []
	var index : int = 0
	var stat_index : int = 0
	
	for ref_item in ref_items_stats:
		if ref_item.name == item_name:
			for ref_stat in ref_item.stats:
				
				var stat_item = load_stat_item(ref_stat)
				
				var stat_name : String = ref_stat.keys()[0]
				var current_stat_level : int = 0
				var stat_value
				
				if stat_upgrade_name == stat_name:
					current_stat_level = player_items_levels[index][stat_name + "_lvl"] + 1
				else:
					current_stat_level = player_items_levels[index][stat_name + "_lvl"]
				
				if (ref_stat[stat_name].min_value is bool) or (ref_stat[stat_name].max_value is bool):
					stat_value = GlobalFunctions.boolean_ratio(ref_stat[stat_name].min_value, ref_stat[stat_name].max_value, ref_stat[stat_name].number_of_levels, current_stat_level, false)
				else:
					stat_value = GlobalFunctions.linear_ratio(ref_stat[stat_name].min_value, ref_stat[stat_name].max_value, ref_stat[stat_name].number_of_levels, current_stat_level, 0)
				
				stat_item.set_stat_name(stat_name)
				stat_item.set_stat_value(stat_value)
				
				var compared_stat_value
				var compared_stat_level = player_items_levels[equiped_item_index][stat_name + "_lvl"]
				var compared_stat = ref_items_stats[equiped_item_index].stats[stat_index][stat_name]
				
				if (compared_stat.min_value is bool) or (compared_stat.max_value is bool):
					compared_stat_value = GlobalFunctions.boolean_ratio(compared_stat.min_value, compared_stat.max_value, compared_stat.number_of_levels, compared_stat_level, false)
				else:
					compared_stat_value = GlobalFunctions.linear_ratio(compared_stat.min_value, compared_stat.max_value, compared_stat.number_of_levels, compared_stat_level, 0)
				stat_item.set_compare_value(compared_stat_value)
				
				stat_list.append(stat_item)
				stat_index += 1
				
		index += 1
	
	return stat_list
