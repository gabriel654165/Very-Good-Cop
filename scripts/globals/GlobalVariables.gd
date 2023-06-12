extends Node

var cursor_position : Vector2 = Vector2.ZERO

var encryption_key := "https://youtu.be/OSkfONBg_QU?!?!".to_ascii_buffer();

var playlists : Dictionary
var playlists_track_names : Dictionary

# Arrays of doors stored at their door bitflag index
# Every door which only has a bottom door will be stored at index [0b0001] so index [1]
var every_room: Array = []
var rooms_repository: Array = []

# VAR TO SAVE
var level : int = 1
var money : int = 0

var grappling_hook_level : int = 1

var index_distance_weapon_selected : int = 0
var index_melee_weapon_selected : int = 0

var player_distance_weapon_list = [
	{
		name= 'glock',
		unlocked = true,
		special_power_unlocked = false,
		shooting_cooldown_lvl= 0,
		balls_by_burt_lvl= -1,
		frequence_of_burt_lvl= -1,
		precision_lvl= 0,
		recoil_force_lvl= 0,
		ammo_size_lvl= 0,
		ammo_reloading_time_lvl= 0,
		projectile_speed_lvl= 0,
		projectile_damages_lvl= 0,
		projectile_impact_force_lvl= 0,
		projectile_bouncing_lvl= -1,
		points_to_use_special_power_lvl= 0,
		auto_lock_target_lvl= -1,
	}, {
		name= 'shotgun',
		unlocked = false,
		special_power_unlocked = false,
		shooting_cooldown_lvl= 0,
		balls_by_burt_lvl= 0,
		frequence_of_burt_lvl= -1,
		precision_lvl= 0,
		recoil_force_lvl= 0,
		ammo_size_lvl= 0,
		ammo_reloading_time_lvl= 0,
		projectile_speed_lvl= 0,
		projectile_damages_lvl= 0,
		projectile_impact_force_lvl= 0,
		projectile_bouncing_lvl= -1,
		points_to_use_special_power_lvl= 0,
		auto_lock_target_lvl= -1,
	}, {
		name= 'mini_uzi',
		unlocked = false,
		special_power_unlocked = false,
		shooting_cooldown_lvl= 0,
		balls_by_burt_lvl= -1,
		frequence_of_burt_lvl= -1,
		precision_lvl= 0,
		recoil_force_lvl= 0,
		ammo_size_lvl= 0,
		ammo_reloading_time_lvl= 0,
		projectile_speed_lvl= 0,
		projectile_damages_lvl= 0,
		projectile_impact_force_lvl= -1,
		projectile_bouncing_lvl= -1,
		points_to_use_special_power_lvl= 0,
		auto_lock_target_lvl= -1,
	}, {
		name= 'riffle',
		unlocked = false,
		special_power_unlocked = false,
		shooting_cooldown_lvl= 0,
		balls_by_burt_lvl= 0,
		frequence_of_burt_lvl= 0,
		precision_lvl= 0,
		recoil_force_lvl= 0,
		ammo_size_lvl= 0,
		ammo_reloading_time_lvl= 0,
		projectile_speed_lvl= 0,
		projectile_damages_lvl= 0,
		projectile_impact_force_lvl= 0,
		projectile_bouncing_lvl= -1,
		points_to_use_special_power_lvl= 0,
		auto_lock_target_lvl= -1,
	}, {
		name= 'machine_gun',
		unlocked = false,
		special_power_unlocked = false,
		shooting_cooldown_lvl= 0,
		balls_by_burt_lvl= -1,
		frequence_of_burt_lvl= -1,
		precision_lvl= 0,
		recoil_force_lvl= 0,
		ammo_size_lvl= 0,
		ammo_reloading_time_lvl= 0,
		projectile_speed_lvl= 0,
		projectile_damages_lvl= 0,
		projectile_impact_force_lvl= 0,
		projectile_bouncing_lvl= -1,
		points_to_use_special_power_lvl= 0,
		auto_lock_target_lvl= -1,
	}, {
		name='grenade_launcher',
		unlocked = false,
		special_power_unlocked = false,
		shooting_cooldown_lvl= 10,
		balls_by_burt_lvl= -1,
		frequence_of_burt_lvl= -1,
		precision_lvl= 0,
		recoil_force_lvl= 0,
		ammo_size_lvl= 0,
		ammo_reloading_time_lvl= 0,
		projectile_speed_lvl= 0,
		projectile_damages_lvl= 0,
		projectile_impact_force_lvl= 0,
		projectile_bouncing_lvl= 0,
		points_to_use_special_power_lvl= 0,
		auto_lock_target_lvl= -1,
	}, {
		name='sniper',
		unlocked = false,
		special_power_unlocked = false,
		shooting_cooldown_lvl= 0,
		balls_by_burt_lvl= -1,
		frequence_of_burt_lvl= -1,
		precision_lvl= 0,
		recoil_force_lvl= 0,
		ammo_size_lvl= 0,
		ammo_reloading_time_lvl= 0,
		projectile_speed_lvl= 0,
		projectile_damages_lvl= 0,
		projectile_impact_force_lvl= -1,
		projectile_bouncing_lvl= -1,
		points_to_use_special_power_lvl= 0,
		auto_lock_target_lvl= 0,
	}
]
# !VAR TO SAVE


func get_distance_weapon_position_by_index(weapon_index: int) -> Vector2:
	var weapon_position := Vector2.ZERO
	var dic_index : int = 0
	
	for weapon_dictionnary in all_distance_weapon_list:
		if dic_index == weapon_index:
			weapon_position = weapon_dictionnary.weapon_position
			break
		dic_index += 1
	return weapon_position

func get_distance_weapon_position_by_name(weapon_name: String) -> Vector2:
	var weapon_position := Vector2.ZERO
	
	for weapon_dictionnary in all_distance_weapon_list:
		if weapon_name == weapon_dictionnary.name:
			weapon_position = weapon_dictionnary.weapon_position
			break
	return weapon_position


func level_stat(min_value, max_value, number_of_levels: int):
	return {
	min_value= min_value,
	max_value= max_value,
	number_of_levels= number_of_levels,
}

var all_distance_weapon_list = [
	{
		name="glock",
		animation="glock_animation",
		weapon_position=Vector2(25, -2),
		projectile_packed_scene=preload("res://scenes/projectiles/Bullet.tscn"),
		gui_texture=load("res://assets/UI/icons/weapons/spr_Pistol.png"),
		shot_shells_texture=load("res://assets/weapons/sprites/projectiles/bullet_1.png"),
		special_power_name= "aim_bot",
		special_power_packed_scene=preload("res://scenes/weapons/special_powers/AimBot.tscn"),
		special_power_preview="res://assets/previews/preview-resized.ogv",
		special_power_description= "This power will locate nearby enemies, place a sight on each of them, and fire directly at them one by one rather quickly.",
		stats= [{
			shooting_cooldown= level_stat(0.75, 0.1, 10),
			type= "property",
		}, {
			balls_by_burt= level_stat(1, 1, 1),#default value
			type= "property",
		}, {
			frequence_of_burt= level_stat(0, 0, 1),#default value
			type= "property",
		}, {
			precision= level_stat(0.5, 0, 6),
			type= "property",
		}, {
			recoil_force= level_stat(1.5, 0, 3),
			type= "property",
		}, {
			ammo_size= level_stat(6, 32, 15),
			type= "ammo",
		}, {
			ammo_reloading_time= level_stat(2, 0.5, 10),
			type= "ammo",
		}, {
			projectile_speed= level_stat(10, 15, 4),
			type= "projectile",
		}, {
			projectile_damages= level_stat(5, 500, 100),#~infinit
			type= "projectile",
		}, {
			projectile_impact_force= level_stat(0.1, 2, 4),
			type= "projectile",
		}, {
			projectile_bouncing= level_stat(false, false, 1),# default value
			type= "projectile",
		}, {
			points_to_use_special_power= level_stat(500, 200, 2),
			type= "power",
		}, {
			auto_lock_target= level_stat(false, false, 1),# default value
			type= "power",
		}]
	},{
		name="shotgun",
		animation="shotgun_animation",
		weapon_position=Vector2(18, 0),
		projectile_packed_scene=preload("res://scenes/projectiles/Bullet.tscn"),
		gui_texture=load("res://assets/UI/icons/weapons/spr_shotgun.png"),
		shot_shells_texture=load("res://assets/weapons/sprites/projectiles/bullet_2.png"),
		special_power_name= "fast_reloading",
		special_power_packed_scene=preload("res://scenes/weapons/special_powers/FastReloading.tscn"),
		special_power_preview="res://assets/previews/preview-resized.ogv",
		special_power_description= "This power will reload your shotgun in just 0.5 seconds after each shot.",
		stats= [{
			shooting_cooldown= level_stat(2, 0.25, 7),
			type= "property",
		}, {
			balls_by_burt= level_stat(3, 12, 8),
			type= "property",
		}, {
			frequence_of_burt= level_stat(0, 0, 1),# default value
			type= "property",
		}, {
			precision= level_stat(1, 0.5, 6),
			type= "property",
		}, {
			recoil_force= level_stat(3, 0.5, 4),
			type= "property",
		}, {
			ammo_size= level_stat(6, 24, 8),
			type= "ammo",
		}, {
			ammo_reloading_time= level_stat(3, 1, 5),
			type= "ammo",
		}, {
			projectile_speed= level_stat(10, 15, 4),
			type= "projectile",
		}, {
			projectile_damages= level_stat(2, 500, 100),#infinit
			type= "projectile",
		}, {
			projectile_impact_force= level_stat(0.1, 1.5, 5),
			type= "projectile",
		}, {
			projectile_bouncing= level_stat(false, false, 1),# default value
			type= "projectile",
		}, {
			points_to_use_special_power= level_stat(500, 200, 2),
			type= "power",
		}, {
			auto_lock_target= level_stat(false, false, 1),# default value
			type= "power",
		}]
	},{
		name="mini_uzi",
		animation="mini_uzi_animation",
		weapon_position=Vector2(29, -4),
		projectile_packed_scene=preload("res://scenes/projectiles/Bullet.tscn"),
		gui_texture=load("res://assets/UI/icons/weapons/spr_Uzi.png"),
		shot_shells_texture=load("res://assets/weapons/sprites/projectiles/bullet_1.png"),
		special_power_name= "bouncing_bullets",
		special_power_packed_scene=preload("res://scenes/weapons/special_powers/BouncingBullets.tscn"),
		special_power_preview="res://assets/previews/preview-resized.ogv",
		special_power_description= "This power will fire bullets that will bounce off the walls.",
		stats= [{
			shooting_cooldown= level_stat(0.2, 0.1, 5),
			type= "property",
		}, {
			balls_by_burt= level_stat(1, 1, 1),# default value
			type= "property",
		}, {
			frequence_of_burt= level_stat(0, 0, 1),# default value
			type= "property",
		}, {
			precision= level_stat(1, 0.25, 6),
			type= "property",
		}, {
			recoil_force= level_stat(0.5, 0, 3),
			type= "property",
		}, {
			ammo_size= level_stat(14, 64, 10),
			type= "ammo",
		}, {
			ammo_reloading_time= level_stat(2, 0.5, 5),
			type= "ammo",
		}, {
			projectile_speed= level_stat(10, 17, 6),
			type= "projectile",
		}, {
			projectile_damages= level_stat(2, 500, 100),#infinit
			type= "projectile",
		}, {
			projectile_impact_force= level_stat(1, 1, 1),# default value
			type= "projectile",
		}, {
			projectile_bouncing= level_stat(false, false, 1),# default value
			type= "projectile",
		}, {
			points_to_use_special_power= level_stat(500, 200, 2),
			type= "power",
		}, {
			auto_lock_target= level_stat(false, false, 1),# default value
			type= "power",
		}]
	},{
		name="riffle",
		animation="riffle_animation",
		weapon_position=Vector2(26, 1),
		projectile_packed_scene=preload("res://scenes/projectiles/Bullet.tscn"),
		gui_texture=load("res://assets/UI/icons/weapons/spr__Aka.png"),
		shot_shells_texture=load("res://assets/weapons/sprites/projectiles/bullet_1.png"),
		special_power_name= "fragmentation_bullets",
		special_power_packed_scene=preload("res://scenes/weapons/special_powers/FragmentationBullets.tscn"),
		special_power_preview="res://assets/previews/preview-resized.ogv",
		special_power_description= "This power will fire bullets that pass through and fragment into 5 parts when they hit an enemy or any other object.",
		stats= [{
			shooting_cooldown= level_stat(1.5, 0.5, 6),
			type= "property",
		}, {
			balls_by_burt= level_stat(3, 9, 4),
			type= "property",
		}, {
			frequence_of_burt= level_stat(0.2, 0.05, 4),
			type= "property",
		}, {
			precision= level_stat(1, 0.1, 6),
			type= "property",
		}, {
			recoil_force= level_stat(0.5, 0.2, 3),
			type= "property",
		}, {
			ammo_size= level_stat(9, 36, 6),
			type= "ammo",
		}, {
			ammo_reloading_time= level_stat(2, 0.5, 5),
			type= "ammo",
		}, {
			projectile_speed= level_stat(10, 20, 6),
			type= "projectile",
		}, {
			projectile_damages= level_stat(10, 500, 100),#infinit
			type= "projectile",
		}, {
			projectile_impact_force= level_stat(0.5, 2, 5),
			type= "projectile",
		}, {
			projectile_bouncing= level_stat(false, false, 1),# default value
			type= "projectile",
		}, {
			points_to_use_special_power= level_stat(500, 200, 2),
			type= "power",
		}, {
			auto_lock_target= level_stat(false, false, 1),# default value
			type= "power",
		}]
	},{
		name="machine_gun",
		animation="machine_gun_animation",
		weapon_position=Vector2(27, 1),
		projectile_packed_scene=preload("res://scenes/projectiles/Bullet.tscn"),
		gui_texture=load("res://assets/UI/icons/weapons/spr_Mg.png"),
		shot_shells_texture=load("res://assets/weapons/sprites/projectiles/bullet_1.png"),
		special_power_name= "shooting_360",
		special_power_packed_scene=preload("res://scenes/weapons/special_powers/Shooting360.tscn"),
		special_power_preview="res://assets/previews/preview-resized.ogv",
		special_power_description= "This power will fire a flurry of bullets as you spin 360 degrees for 4 turns.",
		stats= [{
			shooting_cooldown= level_stat(0.15, 0.05, 3),
			type= "property",
		}, {
			balls_by_burt= level_stat(1, 1, 1),# default value
			type= "property",
		}, {
			frequence_of_burt= level_stat(0, 0, 1),# default value
			type= "property",
		}, {
			precision= level_stat(1, 0.2, 6),
			type= "property",
		}, {
			recoil_force= level_stat(1, 0.25, 3),
			type= "property",
		}, {
			ammo_size= level_stat(24, 52, 10),
			type= "ammo",
		}, {
			ammo_reloading_time= level_stat(3, 1, 6),
			type= "ammo",
		}, {
			projectile_speed= level_stat(10, 15, 6),
			type= "projectile",
		}, {
			projectile_damages= level_stat(5, 500, 100),#infinit
			type= "projectile",
		}, {
			projectile_impact_force= level_stat(0.5, 1.5, 3),
			type= "projectile",
		}, {
			projectile_bouncing= level_stat(false, false, 1),# default value
			type= "projectile",
		}, {
			points_to_use_special_power= level_stat(500, 200, 2),
			type= "power",
		}, {
			auto_lock_target= level_stat(false, false, 1),# default value
			type= "power",
		}]
	},{
		name="grenade_launcher",
		animation="grenade_launcher_animation",
		weapon_position=Vector2(22, 1),
		projectile_packed_scene=preload("res://scenes/projectiles/Grenade.tscn"),
		gui_texture=load("res://assets/UI/icons/weapons/spr_grenade_launcher.png"),
		shot_shells_texture=null,
		special_power_name= "catching_cable",
		special_power_packed_scene=preload("res://scenes/weapons/special_powers/CatchingCable.tscn"),
		special_power_preview="res://assets/previews/preview-resized.ogv",
		special_power_description= "This power will launch a cable that will bring all enemies in its path to a single point.",
		stats= [{
			shooting_cooldown= level_stat(1, 0.1, 10),
			type= "property",
		}, {
			balls_by_burt= level_stat(1, 1, 1),# default value
			type= "property",
		}, {
			frequence_of_burt= level_stat(0, 0, 1),# default value
			type= "property",
		}, {
			precision= level_stat(1, 0.5, 3),
			type= "property",
		}, {
			recoil_force= level_stat(1, 0, 2),
			type= "property",
		}, {
			ammo_size= level_stat(3, 18, 6),
			type= "ammo",
		}, {
			ammo_reloading_time= level_stat(3, 1, 6),
			type= "ammo",
		}, {
			projectile_speed= level_stat(4, 8, 5),
			type= "projectile",
		}, {
			projectile_damages= level_stat(10, 500, 100),#infinit
			type= "projectile",
		}, {
			projectile_impact_force= level_stat(0.5, 3, 6),
			type= "projectile",
		}, {
			projectile_bouncing= level_stat(false, true, 1),
			type= "projectile",
		}, {
			points_to_use_special_power= level_stat(500, 200, 2),
			type= "power",
		}, {
			auto_lock_target= level_stat(false, false, 1),# default value
			type= "power",
		}]
	},{
		name="sniper",
		animation="sniper_animation",
		weapon_position=Vector2(31, 1),
		projectile_packed_scene=preload("res://scenes/projectiles/Bullet.tscn"),
		gui_texture=load("res://assets/UI/icons/weapons/spr_sniper.png"),
		shot_shells_texture=load("res://assets/weapons/sprites/projectiles/bullet_1.png"),
		special_power_name= "throught_wall_bullets",
		special_power_packed_scene=preload("res://scenes/weapons/special_powers/ThroughWallsBullets.tscn"),
		special_power_preview="res://assets/previews/preview-resized.ogv",
		special_power_description= "This power will allow you to fire bullets through walls (the greater the piercing force, the more likely it is to pass through different walls).",
		stats= [{
			shooting_cooldown= level_stat(1.5, 0.25, 6),
			type= "property",
		}, {
			balls_by_burt= level_stat(1, 1, 1),# default value
			type= "property",
		}, {
			frequence_of_burt= level_stat(0, 0, 1),# default value
			type= "property",
		}, {
			precision= level_stat(0.5, 0, 3),
			type= "property",
		}, {
			recoil_force= level_stat(1, 0, 3),
			type= "property",
		}, {
			ammo_size= level_stat(3, 6, 3),
			type= "ammo",
		}, {
			ammo_reloading_time= level_stat(3, 0.5, 5),
			type= "ammo",
		}, {
			projectile_speed= level_stat(15, 30, 6),
			type= "projectile",
		}, {
			projectile_damages= level_stat(15, 500, 100),#infinit
			type= "projectile",
		}, {
			projectile_impact_force= level_stat(1, 1, 1),# default value
			type= "projectile",
		}, {
			projectile_bouncing= level_stat(false, false, 1),# default value
			type= "projectile",
		}, {
			points_to_use_special_power= level_stat(500, 200, 2),
			type= "power",
		}, {
			auto_lock_target= level_stat(false, true, 1),
			type= "power",
		}]
	},
]

# VAR TO SAVE
var player_melee_weapon_list = [
	{
		name= 'police_baton',
		unlocked = true,
		special_power_unlocked = false,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=0,
		points_to_use_special_power_lvl=0,
	}, {
		name= 'knife',
		unlocked= false,
		special_power_unlocked = false,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=0,
		points_to_use_special_power_lvl=0,
	}, {
		name= 'brass_knuckles',
		unlocked = false,
		special_power_unlocked = false,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=-1,
		points_to_use_special_power_lvl=0,
	}, {
		name= 'baseball_bat',
		unlocked = false,
		special_power_unlocked = false,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=0,
		points_to_use_special_power_lvl=0,
	}, {
		name= 'golf_club',
		unlocked = false,
		special_power_unlocked = false,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=-1,
		points_to_use_special_power_lvl=0,
	}, {
		name= 'pocket_chain_saw',
		unlocked = false,
		special_power_unlocked = false,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=-1,
		points_to_use_special_power_lvl=0,
	}, {
		name= 'pan',
		unlocked = false,
		special_power_unlocked = false,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=0,
		points_to_use_special_power_lvl=0,
	}, {
		name= 'tequilla',
		unlocked = false,
		special_power_unlocked = false,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=0,
		points_to_use_special_power_lvl=0,
	}, {
		name= 'heineken',
		unlocked = false,
		special_power_unlocked = false,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=0,
		points_to_use_special_power_lvl=0,
	}, {
		name= 'machete',
		unlocked = false,
		special_power_unlocked = false,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=-1,
		points_to_use_special_power_lvl=0,
	}, {
		name= 'skate',
		unlocked = false,
		special_power_unlocked = false,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=-1,
		points_to_use_special_power_lvl=0,
	}, {
		name= 'axe',
		unlocked = false,
		special_power_unlocked = false,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=-1,
		points_to_use_special_power_lvl=0,
	}, {
		name= 'shovel',
		unlocked = false,
		special_power_unlocked = false,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=-1,
		points_to_use_special_power_lvl=0,
	}, {
		name= 'katana',
		unlocked = false,
		special_power_unlocked = false,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=-1,
		points_to_use_special_power_lvl=0,
	}, {
		name= 'sword',
		unlocked = false,
		special_power_unlocked = false,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=-1,
		points_to_use_special_power_lvl=0,
	}, {
		name= 'blue_lightsaber_toy',
		unlocked = false,
		special_power_unlocked = false,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=0,
		points_to_use_special_power_lvl=0,
	}, {
		name= 'red_lightsaber_toy',
		unlocked = false,
		special_power_unlocked = false,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=0,
		points_to_use_special_power_lvl=0,
	}
]
# !VAR TO SAVE

var all_melee_weapon_list = [
	{
		name= 'police_baton',
		animation="police_baton_animation",
		gui_texture=load("res://assets/weapons/sprites/weapons/police_baton.png"),
		special_power_name= "special_power_name",
		special_power_preview="res://assets/previews/preview-resized.ogv",
		special_power_description= "Coming soon",
		stats= [{
			attack_cooldown= level_stat(1.5, 0.5, 6),
			type= "property",
		}, {
			attack_distance= level_stat(30, 30, 1),#always the same...
			type= "property",
		}, {
			damages= level_stat(7, 50, 10),
			type= "property"
		}, {
			can_throw= level_stat(false, true, 1),
			type= "projectile",
		}, {
			points_to_use_special_power= level_stat(300, 100, 3),
			type= "power",
		}]
	},{
		name="knife",
		animation="knife_animation",
		gui_texture=load("res://assets/weapons/sprites/weapons/spr_Knife.png"),
		special_power_name= "special_power_name",
		special_power_preview="res://assets/previews/preview-resized.ogv",
		special_power_description= "Coming soon",
		stats= [{
			attack_cooldown= level_stat(1, 0.1, 6),
			type= "property",
		}, {
			attack_distance= level_stat(30, 30, 1),#always the same...
			type= "property",
		}, {
			damages= level_stat(9, 50, 15),
			type= "property",
		}, {
			can_throw= level_stat(false, true, 1),
			type= "projectile",
		}, {
			points_to_use_special_power= level_stat(300, 100, 3),#always the same...
			type= "power",
		}]
	},{
		name= 'brass_knuckles',
		animation="brass_knuckles_animation",
		gui_texture=load("res://assets/weapons/sprites/weapons/spr_brass_knuckles.png"),
		special_power_name= "special_power_name",
		special_power_preview="res://assets/previews/preview-resized.ogv",
		special_power_description= "Coming soon",
		stats= [{
			attack_cooldown= level_stat(1, 0.1, 6),
			type= "property",
		}, {
			attack_distance= level_stat(25, 25, 1),#always the same...
			type= "property",
		}, {
			damages= level_stat(8, 30, 10),
			type= "property"
		}, {
			can_throw= level_stat(false, false, 1),# default value
			type= "projectile",
		}, {
			points_to_use_special_power= level_stat(300, 100, 3),
			type= "power",
		}]
	},{
		name= 'baseball_bat',
		animation="baseball_bat_animation",
		gui_texture=load("res://assets/weapons/sprites/weapons/spr_Baseball_Bat.png"),
		special_power_name= "special_power_name",
		special_power_preview="res://assets/previews/preview-resized.ogv",
		special_power_description= "Coming soon",
		stats= [{
			attack_cooldown= level_stat(1.5, 0.35, 6),
			type= "property",
		}, {
			attack_distance= level_stat(35, 35, 1),#always the same...
			type= "property",
		}, {
			damages= level_stat(5, 40, 15),
			type= "property"
		}, {
			can_throw= level_stat(false, true, 1),
			type= "projectile"
		}, {
			points_to_use_special_power= level_stat(300, 100, 3),
			type= "power",
		}]
	},{
		name= 'golf_club',
		animation="golf_club_animation",
		gui_texture=load("res://assets/weapons/sprites/weapons/golf_club.png"),
		special_power_name= "special_power_name",
		special_power_preview="res://assets/previews/preview-resized.ogv",
		special_power_description= "Coming soon",
		stats= [{
			attack_cooldown= level_stat(1.75, 0.5, 6),
			type= "property",
		}, {
			attack_distance= level_stat(40, 40, 1),#always the same...
			type= "property",
		}, {
			damages= level_stat(5, 40, 15),
			type= "property"
		}, {
			can_throw= level_stat(false, false, 1),# default value
			type= "projectile",
		}, {
			points_to_use_special_power= level_stat(300, 100, 3),
			type= "power",
		}]
	},{
		name= 'pocket_chain_saw',
		animation="pocket_chain_saw_animation",
		gui_texture=load("res://assets/weapons/sprites/weapons/pocket_chain_saw.png"),
		special_power_name= "special_power_name",
		special_power_preview="res://assets/previews/preview-resized.ogv",
		special_power_description= "Coming soon",
		stats= [{
			attack_cooldown= level_stat(5, 2.5, 6),
			type= "property",
		}, {
			attack_distance= level_stat(30, 30, 1),#always the same...
			type= "property",
		}, {
			damages= level_stat(1, 10, 10),
			type= "property"
		}, {
			can_throw= level_stat(false, false, 1),# default value
			type= "projectile",
		}, {
			points_to_use_special_power= level_stat(300, 100, 3),
			type= "power",
		}]
	},{
		name= 'pan',
		animation="pan_animation",
		gui_texture=load("res://assets/weapons/sprites/weapons/pan.png"),
		special_power_name= "special_power_name",
		special_power_preview="res://assets/previews/preview-resized.ogv",
		special_power_description= "Coming soon",
		stats= [{
			attack_cooldown= level_stat(1.5, 0.5, 6),
			type= "property",
		}, {
			attack_distance= level_stat(30, 30, 1),#always the same...
			type= "property",
		}, {
			damages= level_stat(2, 10, 5),
			type= "property"
		}, {
			can_throw= level_stat(false, true, 1),
			type= "projectile"
		}, {
			points_to_use_special_power= level_stat(300, 100, 3),
			type= "power",
		}]
	},{
		name= 'tequilla',
		animation="tequilla_animation",
		gui_texture=load("res://assets/weapons/sprites/weapons/tequilla.png"),
		special_power_name= "special_power_name",
		special_power_preview="res://assets/previews/preview-resized.ogv",
		special_power_description= "Coming soon",
		stats= [{
			attack_cooldown= level_stat(2, 0.5, 3),
			type= "property",
		}, {
			attack_distance= level_stat(30, 30, 1),#always the same...
			type= "property",
		}, {
			damages= level_stat(3, 40, 15),
			type= "property"
		}, {
			can_throw= level_stat(false, true, 1),
			type= "projectile"
		}, {
			points_to_use_special_power= level_stat(300, 100, 3),
			type= "power",#saignement
		}]
	},{
		name= 'heineken',
		animation="heineken_animation",
		gui_texture=load("res://assets/weapons/sprites/weapons/henekein.png"),
		special_power_name= "special_power_name",
		special_power_preview="res://assets/previews/preview-resized.ogv",
		special_power_description= "Coming soon",
		stats= [{
			attack_cooldown= level_stat(2, 0.5, 3),
			type= "property",
		}, {
			attack_distance= level_stat(0.5, 0.5, 1),#always the same...
			type= "property",
		}, {
			damages= level_stat(3, 40, 15),
			type= "property"
		}, {
			can_throw= level_stat(false, true, 1),
			type= "projectile"
		}, {
			points_to_use_special_power= level_stat(300, 100, 3),
			type= "power",#saignement
		}]
	},{
		name= 'machete',
		animation="machete_animation",
		gui_texture=load("res://assets/weapons/sprites/weapons/spr_machete.png"),
		special_power_name= "special_power_name",
		special_power_preview="res://assets/previews/preview-resized.ogv",
		special_power_description= "Coming soon",
		stats= [{
			attack_cooldown= level_stat(2, 0.5, 6),
			type= "property",
		}, {
			attack_distance= level_stat(35, 35, 1),#always the same...
			type= "property",
		}, {
			damages= level_stat(10, 60, 15),
			type= "property"
		}, {
			can_throw= level_stat(false, false, 1),# default value
			type= "projectile",
		}, {
			points_to_use_special_power= level_stat(300, 100, 3),
			type= "power",
		}]
	},{
		name= 'skate',
		animation="skate_animation",
		gui_texture=load("res://assets/weapons/sprites/weapons/skate.png"),
		special_power_name= "special_power_name",
		special_power_preview="res://assets/previews/preview-resized.ogv",
		special_power_description= "Coming soon",
		stats= [{
			attack_cooldown= level_stat(1, 0.5, 6),
			type= "property",
		}, {
			attack_distance= level_stat(30, 30, 1),#always the same...
			type= "property",
		}, {
			damages= level_stat(5, 35, 12),
			type= "property"
		}, {
			can_throw= level_stat(false, false, 1),# default value
			type= "projectile",
		}, {
			points_to_use_special_power= level_stat(300, 100, 3),
			type= "power",
		}]
	},{
		name= 'axe',
		animation="axe_animation",
		gui_texture=load("res://assets/weapons/sprites/weapons/axe.png"),
		special_power_name= "special_power_name",
		special_power_preview="res://assets/previews/preview-resized.ogv",
		special_power_description= "Coming soon",
		stats= [{
			attack_cooldown= level_stat(3.5, 0.75, 6),
			type= "property",
		}, {
			attack_distance= level_stat(35, 35, 1),#always the same...
			type= "property",
		}, {
			damages= level_stat(13, 70, 20),
			type= "property"
		}, {
			can_throw= level_stat(false, false, 1),# default value
			type= "projectile",
		}, {
			points_to_use_special_power= level_stat(300, 100, 3),
			type= "power",
		}]
	},{
		name= 'shovel',
		animation="shovel_animation",
		gui_texture=load("res://assets/weapons/sprites/weapons/spr_shovel.png"),
		special_power_name= "special_power_name",
		special_power_preview="res://assets/previews/preview-resized.ogv",
		special_power_description= "Coming soon",
		stats= [{
			attack_cooldown= level_stat(3, 0.6, 6),
			type= "property",
		}, {
			attack_distance= level_stat(35, 35, 1),#always the same...
			type= "property",
		}, {
			damages= level_stat(7, 40, 12),
			type= "property"
		}, {
			can_throw= level_stat(false, false, 1),# default value
			type= "projectile",
		}, {
			points_to_use_special_power= level_stat(300, 100, 3),
			type= "power",
		}]
	},{
		name= 'katana',
		animation="katana_animation",
		gui_texture=load("res://assets/weapons/sprites/weapons/katana.png"),
		special_power_name= "special_power_name",
		special_power_preview="res://assets/previews/preview-resized.ogv",
		special_power_description= "Coming soon",
		stats= [{
			attack_cooldown= level_stat(2, 0.1, 12),
			type= "property",
		}, {
			attack_distance= level_stat(35, 35, 1),#always the same...
			type= "property",
		}, {
			damages= level_stat(12, 100, 22),
			type= "property"
		}, {
			can_throw= level_stat(false, false, 1),# default value
			type= "projectile",
		}, {
			points_to_use_special_power= level_stat(300, 100, 3),
			type= "power",
		}]
	},{
		name= 'sword',
		animation="sword_animation",
		gui_texture=load("res://assets/weapons/sprites/weapons/spr_sword.png"),
		special_power_name= "special_power_name",
		special_power_preview="res://assets/previews/preview-resized.ogv",
		special_power_description= "Coming soon",
		stats= [{
			attack_cooldown= level_stat(3, 0.5, 12),
			type= "property",
		}, {
			attack_distance= level_stat(32, 32, 1),#always the same...
			type= "property",
		}, {
			damages= level_stat(15, 115, 22),
			type= "property",
		}, {
			can_throw= level_stat(false, false, 1),# default value
			type= "projectile",
		}, {
			points_to_use_special_power= level_stat(300, 100, 3),
			type= "power",
		}]
	},{
		name= 'blue_lightsaber_toy',
		animation="blue_lightsaber_toy_animation",
		gui_texture=load("res://assets/weapons/sprites/weapons/spr_blue_lightsaber_toy.png"),
		special_power_name= "special_power_name",
		special_power_preview="res://assets/previews/preview-resized.ogv",
		special_power_description= "Coming soon",
		stats= [{
			attack_cooldown= level_stat(5, 0.1, 15),
			type= "property",
		}, {
			attack_distance= level_stat(35, 35, 1),#always the same...
			type= "property",
		}, {
			damages= level_stat(15, 150, 22),
			type= "property"
		}, {
			can_throw= level_stat(false, true, 1),
			type= "projectile"
		}, {
			points_to_use_special_power= level_stat(300, 100, 3),
			type= "power",
		}]
	},{
		name= 'red_lightsaber_toy',
		animation="red_lightsaber_toy_animation",
		gui_texture=load("res://assets/weapons/sprites/weapons/spr_red_lightsaber_toy.png"),
		special_power_name= "special_power_name",
		special_power_preview="res://assets/previews/preview-resized.ogv",
		special_power_description= "Coming soon",
		stats= [{
			attack_cooldown= level_stat(5, 0.1, 15),
			type= "property",
		}, {
			attack_distance= level_stat(35, 35, 1),#always the same...
			type= "property",
		}, {
			damages= level_stat(15, 150, 22),
			type= "property"
		}, {
			can_throw= level_stat(false, true, 1),
			type= "projectile"
		}, {
			points_to_use_special_power= level_stat(300, 100, 3),
			type= "power",
		}]
	}
]

# VAR TO SAVE
var player_equipment_list = [
	{
		name= 'diaper',
		unlocked= false,
		health_bonus_lvl= 0,
		speed_bonus_lvl= -1,
	}, {
		name= 'bullet_proof_vest',
		unlocked= false,
		health_bonus_lvl= 0,
		speed_bonus_lvl= -1,
	}, {
		name= 'air_max',
		unlocked= false,
		health_bonus_lvl= -1,
		speed_bonus_lvl= 0,
	}, {
		name= 'gas_mask',
		unlocked= false,
		health_bonus_lvl= -1,
		speed_bonus_lvl= -1,
	}
]
# !VAR TO SAVE

var all_equipment_list = [
	{
		name= 'diaper',
		gui_texture=load("res://assets/UI/icons/equipment/diaper.png"),
		stats= [{
			health_bonus= level_stat(0.5, 10, 10),
			type= "property"
		}, {
			speed_bonus= level_stat(0, 0, 1),# default value
			type= "property"
		}]
	}, {
		name= 'bullet_proof_vest',
		gui_texture=load("res://assets/UI/icons/equipment/bulletproof_vest.png"),
		stats= [{
			health_bonus= level_stat(10, 100, 20),
			type= "property"
		}, {
			speed_bonus= level_stat(0, 0, 1),# default value
			type= "property"
		}]
	}, {
		name= 'air_max',
		gui_texture=load("res://assets/UI/icons/equipment/air_max.png"),
		stats= [{
			health_bonus= level_stat(0, 0, 1),# default value
			type= "property"
		}, {
			speed_bonus= level_stat(1, 4, 20),
			type= "property"
		}]
	}, {
		name= 'gas_mask',
		gui_texture=load("res://assets/UI/icons/equipment/gas_mask.png"),
		stats= [{
			health_bonus= level_stat(0, 0, 1),# default value
			type= "property"
		}, {
			speed_bonus= level_stat(0, 0, 1),# default value
			type= "property"
		}]
	}
]
