extends Node

var cursor_position : Vector2 = Vector2.ZERO

var encryption_key := "https://youtu.be/OSkfONBg_QU?!?!".to_ascii_buffer();

# Arrays of doors stored at their door bitflag index
# Every door which only has a bottom door will be stored at index [0b0001] so index [1]
var every_room: Array = []
var rooms_repository: Array = []

# VAR TO SAVE
var level : int = 1
var money : int = 500

var grappling_hook_level : int = 1

var index_distance_weapon_selected : int = 0
var index_melee_weapon_selected : int = 0

#si glock a auto_lock=-1, la valeur weapon.auto_lock=true va rester
# il faudrait mettre une valeure par defaut dans all_distance_weapon_list
# avec 1 seul niveau et min = max

# dans globalFunctions quand c -1 on met la valeure par defaut

var player_distance_weapon_list = [
	{
		name= 'glock',
		unlocked = true,
		shooting_cooldown_lvl= 0,
		balls_by_burt_lvl= -1,
		frequence_of_burt_lvl= -1,
		precision_lvl= 6,
		recoil_force_lvl= 0,
		ammo_size_lvl= 0,
		ammo_reloading_time_lvl= 0,
		projectile_speed_lvl= 0,
		projectile_damages_lvl= 0,
		projectile_impact_force_lvl= 0,
		projectile_bouncing_lvl= -1,
		special_power_cooldown_lvl= 0,
		auto_lock_target_lvl= -1,
	}, {
		name= 'shotgun',
		unlocked = true,
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
		special_power_cooldown_lvl= 0,
		auto_lock_target_lvl= -1,
	}, {
		name= 'mini_uzi',
		unlocked = true,
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
		special_power_cooldown_lvl= 0,
		auto_lock_target_lvl= -1,
	}, {
		name= 'riffle',
		unlocked = true,
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
		special_power_cooldown_lvl= 0,
		auto_lock_target_lvl= -1,
	}, {
		name= 'machine_gun',
		unlocked = true,
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
		special_power_cooldown_lvl= 0,
		auto_lock_target_lvl= -1,
	}, {
		name='grenade_launcher',
		unlocked = true,
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
		special_power_cooldown_lvl= 0,
		auto_lock_target_lvl= -1,
	}, {
		name='sniper',
		unlocked = true,
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
		special_power_cooldown_lvl= 0,
		auto_lock_target_lvl= 0,
	}
]
# !VAR TO SAVE

func level_stat(min_value, max_value, number_of_levels: int):
	return {
	min_value= min_value,
	max_value= max_value,
	number_of_levels= number_of_levels,
}

var all_distance_weapon_list = [
	{
		name="glock",
		projectile_packed_scene=preload("res://scenes/projectiles/bullet.tscn"),
		special_power_packed_scene=preload("res://scenes/weapons/special_powers/AimBot.tscn"),
		gui_texture=load("res://assets/UI/icons/weapons/spr_Pistol.png"),
		stats= [{
			shooting_cooldown= level_stat(1, 0.1, 10),
			texture_ui=load("res://assets/UI/icons/weapons/spr_Pistol.png"),
		}, {
			balls_by_burt= level_stat(1, 1, 1)#default value
		}, {
			frequence_of_burt= level_stat(0, 0, 1)#default value
		}, {
			precision= level_stat(0.5, 0, 6)
		}, {
			recoil_force= level_stat(1.5, 0, 3)
		}, {
			ammo_size= level_stat(6, 32, 15)
		}, {
			ammo_reloading_time= level_stat(2, 0.5, 10)
		}, {
			projectile_speed= level_stat(10, 15, 4)
		}, {
			projectile_damages= level_stat(5, 500, 100)#~infinit
		}, {
			projectile_impact_force= level_stat(0.1, 2, 4)
		}, {
			projectile_bouncing= level_stat(false, false, 1)# default value
		}, {
			special_power_cooldown= level_stat(120, 30, 6)
		}, {
			auto_lock_target= level_stat(false, false, 1)# default value
		}]
	},{
		name="shotgun",
		projectile_packed_scene=preload("res://scenes/projectiles/bullet.tscn"),
		special_power_packed_scene=preload("res://scenes/weapons/special_powers/FastReloading.tscn"),
		gui_texture=load("res://assets/UI/icons/weapons/spr_shotgun.png"),
		stats= [{
			shooting_cooldown= level_stat(2, 0.25, 7)
		}, {
			balls_by_burt= level_stat(3, 12, 8)
		}, {
			frequence_of_burt= level_stat(0, 0, 1)# default value
		}, {
			precision= level_stat(1, 0.5, 6)
		}, {
			recoil_force= level_stat(3, 0.5, 4)
		}, {
			ammo_size= level_stat(6, 24, 8)
		}, {
			ammo_reloading_time= level_stat(3, 1, 5)
		}, {
			projectile_speed= level_stat(10, 15, 4)
		}, {
			projectile_damages= level_stat(2, 500, 100)#infinit
		}, {
			projectile_impact_force= level_stat(0.1, 1.5, 5)
		}, {
			projectile_bouncing= level_stat(false, false, 1)# default value
		}, {
			special_power_cooldown= level_stat(120, 30, 6)
		}, {
			auto_lock_target= level_stat(false, false, 1)# default value
		}]
	},{
		name="mini_uzi",
		projectile_packed_scene=preload("res://scenes/projectiles/bullet.tscn"),
		special_power_packed_scene=preload("res://scenes/weapons/special_powers/BouncingBullets.tscn"),
		gui_texture=load("res://assets/UI/icons/weapons/spr_Uzi.png"),
		stats= [{
			shooting_cooldown= level_stat(0.2, 0.1, 5)
		}, {
			balls_by_burt= level_stat(1, 1, 1)# default value
		}, {
			frequence_of_burt= level_stat(0, 0, 1)# default value
		}, {
			precision= level_stat(1, 0.25, 6)
		}, {
			recoil_force= level_stat(0.5, 0, 3)
		}, {
			ammo_size= level_stat(14, 64, 10)
		}, {
			ammo_reloading_time= level_stat(2, 0.5, 5)
		}, {
			projectile_speed= level_stat(10, 17, 6)
		}, {
			projectile_damages= level_stat(2, 500, 100)#infinit
		}, {
			projectile_impact_force= level_stat(1, 1, 1)# default value
		}, {
			projectile_bouncing= level_stat(false, false, 1)# default value
		}, {
			special_power_cooldown= level_stat(120, 30, 6)
		}, {
			auto_lock_target= level_stat(false, false, 1)# default value
		}]
	},{
		name="riffle",
		projectile_packed_scene=preload("res://scenes/projectiles/bullet.tscn"),
		special_power_packed_scene=preload("res://scenes/weapons/special_powers/FragmentationBullets.tscn"),
		gui_texture=load("res://assets/UI/icons/weapons/spr__Aka.png"),
		stats= [{
			shooting_cooldown= level_stat(1.5, 0.5, 6)
		}, {
			balls_by_burt= level_stat(3, 9, 4)
		}, {
			frequence_of_burt= level_stat(0.2, 0.05, 4)
		}, {
			precision= level_stat(1, 0.1, 6)
		}, {
			recoil_force= level_stat(0.5, 0.2, 3)
		}, {
			ammo_size= level_stat(9, 36, 6)
		}, {
			ammo_reloading_time= level_stat(2, 0.5, 5)
		}, {
			projectile_speed= level_stat(10, 20, 6)
		}, {
			projectile_damages= level_stat(10, 500, 100)#infinit
		}, {
			projectile_impact_force= level_stat(0.5, 2, 5)
		}, {
			projectile_bouncing= level_stat(false, false, 1)# default value
		}, {
			special_power_cooldown= level_stat(120, 30, 6)
		}, {
			auto_lock_target= level_stat(false, false, 1)# default value
		}]
	},{
		name="machine_gun",
		projectile_packed_scene=preload("res://scenes/projectiles/bullet.tscn"),
		special_power_packed_scene=preload("res://scenes/weapons/special_powers/Shooting360.tscn"),
		gui_texture=load("res://assets/UI/icons/weapons/spr_Mg.png"),
		stats= [{
			shooting_cooldown= level_stat(0.15, 0.05, 3)
		}, {
			balls_by_burt= level_stat(1, 1, 1)# default value
		}, {
			frequence_of_burt= level_stat(0, 0, 1)# default value
		}, {
			precision= level_stat(1, 0.2, 6)
		}, {
			recoil_force= level_stat(1, 0.25, 3)
		}, {
			ammo_size= level_stat(24, 52, 10)
		}, {
			ammo_reloading_time= level_stat(3, 1, 6)
		}, {
			projectile_speed= level_stat(10, 15, 6)
		}, {
			projectile_damages= level_stat(5, 500, 100)#infinit
		}, {
			projectile_impact_force= level_stat(0.5, 1.5, 3)
		}, {
			projectile_bouncing= level_stat(false, false, 1)# default value
		}, {
			special_power_cooldown= level_stat(120, 30, 6)
		}, {
			auto_lock_target= level_stat(false, false, 1)# default value
		}]
	},{
		name="grenade_launcher",
		projectile_packed_scene=preload("res://scenes/projectiles/grenade.tscn"),
		special_power_packed_scene=preload("res://scenes/weapons/special_powers/CatchingCable.tscn"),
		gui_texture=load("res://assets/UI/icons/weapons/spr_grenade_launcher.png"),
		stats= [{
			shooting_cooldown= level_stat(1, 0.1, 10)
		}, {
			balls_by_burt= level_stat(1, 1, 1)# default value
		}, {
			frequence_of_burt= level_stat(0, 0, 1)# default value
		}, {
			precision= level_stat(1, 0.5, 3)
		}, {
			recoil_force= level_stat(1, 0, 2)
		}, {
			ammo_size= level_stat(3, 18, 6)
		}, {
			ammo_reloading_time= level_stat(3, 1, 6)
		}, {
			projectile_speed= level_stat(4, 8, 5)
		}, {
			projectile_damages= level_stat(10, 500, 100)#infinit
		}, {
			projectile_impact_force= level_stat(0.5, 3, 6)
		}, {
			projectile_bouncing= level_stat(false, true, 1)
		}, {
			special_power_cooldown= level_stat(120, 30, 6)
		}, {
			auto_lock_target= level_stat(false, false, 1)# default value
		}]
	},{
		name="sniper",
		projectile_packed_scene=preload("res://scenes/projectiles/bullet.tscn"),
		special_power_packed_scene=preload("res://scenes/weapons/special_powers/ThroughWallsBullets.tscn"),
		gui_texture=load("res://assets/UI/icons/weapons/spr_sniper.png"),
		stats= [{
			shooting_cooldown= level_stat(1.5, 0.25, 6)
		}, {
			balls_by_burt= level_stat(1, 1, 1)# default value
		}, {
			frequence_of_burt= level_stat(0, 0, 1)# default value
		}, {
			precision= level_stat(0.5, 0, 3)
		}, {
			recoil_force= level_stat(1, 0, 3)
		}, {
			ammo_size= level_stat(3, 6, 3)
		}, {
			ammo_reloading_time= level_stat(3, 0.5, 5)
		}, {
			projectile_speed= level_stat(15, 30, 6)
		}, {
			projectile_damages= level_stat(15, 500, 100)#infinit
		}, {
			projectile_impact_force= level_stat(1, 1, 1)# default value
		}, {
			projectile_bouncing= level_stat(false, false, 1)# default va
		}, {
			special_power_cooldown= level_stat(120, 30, 6)
		}, {
			auto_lock_target= level_stat(false, true, 1)
		}]
	},
]

# VAR TO SAVE
var player_melee_weapon_list = [
	{
		name= 'knife',
		unlocked= true,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=0,
		special_power_cooldown_lvl=0,
	}, {
		name= 'brass_knuckles',
		unlocked = true,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=-1,
		special_power_cooldown_lvl=0,
	}, {
		name= 'baseball_bat',
		unlocked = true,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=0,
		special_power_cooldown_lvl=0,
	}, {
		name= 'golf_club',
		unlocked = true,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=-1,
		special_power_cooldown_lvl=0,
	}, {
		name= 'pocket_chain_saw',
		unlocked = true,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=-1,
		special_power_cooldown_lvl=0,
	}, {
		name= 'pan',
		unlocked = true,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=0,
		special_power_cooldown_lvl=0,
	}, {
		name= 'tequilla',
		unlocked = true,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=0,
		special_power_cooldown_lvl=0,
	}, {
		name= 'heineken',
		unlocked = true,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=0,
		special_power_cooldown_lvl=0,
	}, {
		name= 'machete',
		unlocked = true,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=-1,
		special_power_cooldown_lvl=0,
	}, {
		name= 'skate',
		unlocked = true,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=-1,
		special_power_cooldown_lvl=0,
	}, {
		name= 'police_baton',
		unlocked = true,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=0,
		special_power_cooldown_lvl=0,
	}, {
		name= 'axe',
		unlocked = true,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=-1,
		special_power_cooldown_lvl=0,
	}, {
		name= 'shovel',
		unlocked = true,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=-1,
		special_power_cooldown_lvl=0,
	}, {
		name= 'katana',
		unlocked = true,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=-1,
		special_power_cooldown_lvl=0,
	}, {
		name= 'sword',
		unlocked = true,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=-1,
		special_power_cooldown_lvl=0,
	}, {
		name= 'blue_lightsaber_toy',
		unlocked = true,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=0,
		special_power_cooldown_lvl=0,
	}, {
		name= 'red_lightsaber_toy',
		unlocked = true,
		attack_cooldown_lvl= 0,
		attack_distance_lvl= 0,
		damages_lvl=0,
		can_throw_lvl=0,
		special_power_cooldown_lvl=0,
	}
]
# !VAR TO SAVE

var all_melee_weapon_list = [
	{
		name="knife",
		gui_texture=load("res://assets/UI/icons/weapons/spr_Knife.png"),
		stats= [{
			attack_cooldown= level_stat(1, 0.1, 6)
		}, {
			attack_distance= level_stat(1, 1, 1)#always the same...
		}, {
			damages= level_stat(7, 50, 15)
		}, {
			can_throw= level_stat(false, true, 1)
		}, {
			special_power_cooldown= level_stat(120, 30, 6)
		}]
	},{
		name= 'brass_knuckles',
		gui_texture=load("res://assets/UI/icons/weapons/spr_brass_knuckles.png"),
		stats= [{
			attack_cooldown= level_stat(1, 0.1, 6)
		}, {
			attack_distance= level_stat(0.2, 0.2, 1)#always the same...
		}, {
			damages= level_stat(8, 30, 10)
		}, {
			can_throw= level_stat(false, false, 1)# default value
		}, {
			special_power_cooldown= level_stat(120, 30, 6)
		}]
	},{
		name= 'baseball_bat',
		gui_texture=load("res://assets/UI/icons/weapons/spr_Baseball_Bat.png"),
		stats= [{
			attack_cooldown= level_stat(1.5, 0.35, 6)
		}, {
			attack_distance= level_stat(1.5, 1.5, 1)#always the same...
		}, {
			damages= level_stat(5, 40, 15)
		}, {
			can_throw= level_stat(false, true, 1)
		}, {
			special_power_cooldown= level_stat(120, 30, 6)
		}]
	},{
		name= 'golf_club',
		gui_texture=load("res://assets/UI/icons/weapons/golf_club.png"),
		stats= [{
			attack_cooldown= level_stat(1.75, 0.5, 6)
		}, {
			attack_distance= level_stat(1.75, 1.75, 1)#always the same...
		}, {
			damages= level_stat(5, 40, 15)
		}, {
			can_throw= level_stat(false, false, 1)# default value
		}, {
			special_power_cooldown= level_stat(120, 30, 6)
		}]
	},{
		name= 'pocket_chain_saw',
		gui_texture=load("res://assets/UI/icons/weapons/pocket_chain_saw.png"),
		stats= [{
			attack_cooldown= level_stat(5, 2.5, 6)
		}, {
			attack_distance= level_stat(0.5, 0.5, 1)#always the same...
		}, {
			damages= level_stat(1, 10, 10)
		}, {
			can_throw= level_stat(false, false, 1)# default value
		}, {
			special_power_cooldown= level_stat(120, 30, 6)
		}]
	},{
		name= 'pan',
		gui_texture=load("res://assets/UI/icons/weapons/pan.png"),
		stats= [{
			attack_cooldown= level_stat(1.5, 0.5, 6)
		}, {
			attack_distance= level_stat(0.5, 0.5, 1)#always the same...
		}, {
			damages= level_stat(2, 10, 5)
		}, {
			can_throw= level_stat(false, true, 1)
		}, {
			special_power_cooldown= level_stat(120, 30, 6)
		}]
	},{
		name= 'tequilla',
		gui_texture=load("res://assets/UI/icons/weapons/tequilla.png"),
		stats= [{
			attack_cooldown= level_stat(2, 0.5, 3)
		}, {
			attack_distance= level_stat(0.5, 0.5, 1)#always the same...
		}, {
			damages= level_stat(3, 40, 15)
		}, {
			can_throw= level_stat(false, true, 1)
		}, {
			special_power_cooldown= level_stat(120, 30, 6)#saignement
		}]
	},{
		name= 'heineken',
		gui_texture=load("res://assets/UI/icons/weapons/henekein.png"),
		stats= [{
			attack_cooldown= level_stat(2, 0.5, 3)
		}, {
			attack_distance= level_stat(0.5, 0.5, 1)#always the same...
		}, {
			damages= level_stat(3, 40, 15)
		}, {
			can_throw= level_stat(false, true, 1)
		}, {
			special_power_cooldown= level_stat(120, 30, 6)#saignement
		}]
	},{
		name= 'machete',
		gui_texture=load("res://assets/UI/icons/weapons/spr_machete.png"),
		stats= [{
			attack_cooldown= level_stat(2, 0.5, 6)
		}, {
			attack_distance= level_stat(1.25, 1.25, 1)#always the same...
		}, {
			damages= level_stat(10, 60, 15)
		}, {
			can_throw= level_stat(false, false, 1)# default value
		}, {
			special_power_cooldown= level_stat(120, 30, 6)
		}]
	},{
		name= 'skate',
		gui_texture=load("res://assets/UI/icons/weapons/skate.png"),
		stats= [{
			attack_cooldown= level_stat(1, 0.5, 6)
		}, {
			attack_distance= level_stat(0.75, 0.75, 1)#always the same...
		}, {
			damages= level_stat(5, 35, 12)
		}, {
			can_throw= level_stat(false, false, 1)# default value
		}, {
			special_power_cooldown= level_stat(120, 30, 6)
		}]
	},{
		name= 'police_baton',
		gui_texture=load("res://assets/UI/icons/weapons/police_baton.png"),
		stats= [{
			attack_cooldown= level_stat(1.5, 0.5, 6)
		}, {
			attack_distance= level_stat(0.65, 0.65, 1)#always the same...
		}, {
			damages= level_stat(7, 50, 10)
		}, {
			can_throw= level_stat(false, true, 1)
		}, {
			special_power_cooldown= level_stat(120, 30, 6)
		}]
	},{
		name= 'axe',
		gui_texture=load("res://assets/UI/icons/weapons/axe.png"),
		stats= [{
			attack_cooldown= level_stat(3.5, 0.75, 6)
		}, {
			attack_distance= level_stat(1.35, 1.35, 1)#always the same...
		}, {
			damages= level_stat(13, 70, 20)
		}, {
			can_throw= level_stat(false, false, 1)# default value
		}, {
			special_power_cooldown= level_stat(120, 30, 6)
		}]
	},{
		name= 'shovel',
		gui_texture=load("res://assets/UI/icons/weapons/spr_shovel.png"),
		stats= [{
			attack_cooldown= level_stat(3, 0.6, 6)
		}, {
			attack_distance= level_stat(1.4, 1.4, 1)#always the same...
		}, {
			damages= level_stat(7, 40, 12)
		}, {
			can_throw= level_stat(false, false, 1)# default value
		}, {
			special_power_cooldown= level_stat(120, 30, 6)
		}]
	},{
		name= 'katana',
		gui_texture=load("res://assets/UI/icons/weapons/katana.png"),
		stats= [{
			attack_cooldown= level_stat(2, 0.1, 12)
		}, {
			attack_distance= level_stat(1.3, 1.3, 1)#always the same...
		}, {
			damages= level_stat(12, 100, 22)
		}, {
			can_throw= level_stat(false, false, 1)# default value
		}, {
			special_power_cooldown= level_stat(120, 30, 6)
		}]
	},{
		name= 'sword',
		gui_texture=load("res://assets/UI/icons/weapons/spr_sword.png"),
		stats= [{
			attack_cooldown= level_stat(3, 0.5, 12)
		}, {
			attack_distance= level_stat(1.1, 1.1, 1)#always the same...
		}, {
			damages= level_stat(15, 115, 22)
		}, {
			can_throw= level_stat(false, false, 1)# default value
		}, {
			special_power_cooldown= level_stat(120, 30, 6)
		}]
	},{
		name= 'blue_lightsaber_toy',
		gui_texture=load("res://assets/UI/icons/weapons/spr_blue_lightsaber_toy.png"),
		stats= [{
			attack_cooldown= level_stat(5, 0.1, 15)
		}, {
			attack_distance= level_stat(1.3, 1.3, 1)#always the same...
		}, {
			damages= level_stat(15, 150, 22)
		}, {
			can_throw= level_stat(false, true, 1)
		}, {
			special_power_cooldown= level_stat(120, 30, 6)
		}]
	},{
		name= 'red_lightsaber_toy',
		gui_texture=load("res://assets/UI/icons/weapons/spr_red_lightsaber_toy.png"),
		stats= [{
			attack_cooldown= level_stat(5, 0.1, 15)
		}, {
			attack_distance= level_stat(1.3, 1.3, 1)#always the same...
		}, {
			damages= level_stat(15, 150, 22)
		}, {
			can_throw= level_stat(false, true, 1)
		}, {
			special_power_cooldown= level_stat(120, 30, 6)
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
		}, {
			speed_bonus= level_stat(0, 0, 1),# default value
		}]
	}, {
		name= 'bullet_proof_vest',
		gui_texture=load("res://assets/UI/icons/equipment/bulletproof_vest.png"),
		stats= [{
			health_bonus= level_stat(10, 100, 20),
		}, {
			speed_bonus= level_stat(0, 0, 1),# default value
		}]
	}, {
		name= 'air_max',
		gui_texture=load("res://assets/UI/icons/equipment/air_max.png"),
		stats= [{
			health_bonus= level_stat(0, 0, 1),# default value
		}, {
			speed_bonus= level_stat(1, 4, 20),
		}]
	}, {
		name= 'gas_mask',
		gui_texture=load("res://assets/UI/icons/equipment/gas_mask.png"),
		stats= [{
			health_bonus= level_stat(0, 0, 1),# default value
		}, {
			speed_bonus= level_stat(0, 0, 1),# default value
		}]
	}
]
