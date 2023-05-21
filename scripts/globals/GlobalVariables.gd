extends Node

var cursor_position : Vector2 = Vector2.ZERO

var encryption_key := "https://youtu.be/OSkfONBg_QU?!?!".to_ascii_buffer();

# Arrays of doors stored at their door bitflag index
# Every door which only has a bottom door will be stored at index [0b0001] so index [1]
var every_room: Array = []
var rooms_repository: Array = []

# VAR TO SAVE
var level : int = 1
var money : int = 0

var knife_level : int = 1

var grappling_hook_level : int = 1
var bulletproof_vest_level : int = 0

var index_weapon_selected : int = 0
var index_knife_selected : int = 0

var player_weapon_list = [
	{
		name= 'glock',
		unlocked = true,
		shooting_cooldown_level= 1,
		balls_by_burt_level= 0,
		frequence_of_burt_level= 0,
		precision_level= 6,
		recoil_force_level= 1,
		ammo_size_level= 1,
		ammo_reloading_time_level= 1,
		projectile_speed_level= 1,
		projectile_damages_level= 1,
		projectile_impact_force_level= 1,
		projectile_bouncing_level= 0,
		special_power_cooldown_level= 1,
		auto_lock_target_level= 0,
	}, {
		name= 'shotgun',
		unlocked = true,
		shooting_cooldown_level= 1,
		balls_by_burt_level= 1,
		frequence_of_burt_level= 0,
		precision_level= 1,
		recoil_force_level= 1,
		ammo_size_level= 1,
		ammo_reloading_time_level= 1,
		projectile_speed_level= 1,
		projectile_damages_level= 1,
		projectile_impact_force_level= 1,
		projectile_bouncing_level= 0,
		special_power_cooldown_level= 1,
		auto_lock_target_level= 0,
	}, {
		name= 'mini_uzi',
		unlocked = true,
		shooting_cooldown_level= 1,
		balls_by_burt_level= 0,
		frequence_of_burt_level= 0,
		precision_level= 1,
		recoil_force_level= 1,
		ammo_size_level= 1,
		ammo_reloading_time_level= 1,
		projectile_speed_level= 1,
		projectile_damages_level= 1,
		projectile_impact_force_level= 0,
		projectile_bouncing_level= 0,
		special_power_cooldown_level= 1,
		auto_lock_target_level= 0,
	}, {
		name= 'riffle',
		unlocked = true,
		shooting_cooldown_level= 1,
		balls_by_burt_level= 1,
		frequence_of_burt_level= 1,
		precision_level= 1,
		recoil_force_level= 1,
		ammo_size_level= 1,
		ammo_reloading_time_level= 1,
		projectile_speed_level= 1,
		projectile_damages_level= 1,
		projectile_impact_force_level= 1,
		projectile_bouncing_level= 0,
		special_power_cooldown_level= 1,
		auto_lock_target_level= 0,
	}, {
		name= 'machine_gun',
		unlocked = true,
		shooting_cooldown_level= 1,
		balls_by_burt_level= 0,
		frequence_of_burt_level= 0,
		precision_level= 1,
		recoil_force_level= 1,
		ammo_size_level= 1,
		ammo_reloading_time_level= 1,
		projectile_speed_level= 1,
		projectile_damages_level= 1,
		projectile_impact_force_level= 1,
		projectile_bouncing_level= 0,
		special_power_cooldown_level= 1,
		auto_lock_target_level= 0,
	}, {
		name='grenade_launcher',
		unlocked = true,
		shooting_cooldown_level= 10,
		balls_by_burt_level= 0,
		frequence_of_burt_level= 0,
		precision_level= 1,
		recoil_force_level= 1,
		ammo_size_level= 1,
		ammo_reloading_time_level= 1,
		projectile_speed_level= 1,
		projectile_damages_level= 1,
		projectile_impact_force_level= 1,
		projectile_bouncing_level= 1,
		special_power_cooldown_level= 1,
		auto_lock_target_level= 0,
	}, {
		name='sniper',
		unlocked = true,
		shooting_cooldown_level= 1,
		balls_by_burt_level= 0,
		frequence_of_burt_level= 0,
		precision_level= 1,
		recoil_force_level= 1,
		ammo_size_level= 1,
		ammo_reloading_time_level= 1,
		projectile_speed_level= 1,
		projectile_damages_level= 1,
		projectile_impact_force_level= 0,
		projectile_bouncing_level= 0,
		special_power_cooldown_level= 1,
		auto_lock_target_level= 1,
	}
]
# !VAR TO SAVE

func level_stat(min_value, max_value, number_of_levels: int):
	return {
	min_value= min_value,
	max_value= max_value,
	number_of_levels= number_of_levels,
}

var all_weapon_list = [
	{
		name="glock",
		packed_scene=preload("res://scenes/weapons/Glock.tscn"),
		projectile_packed_scene=preload("res://scenes/projectiles/bullet.tscn"),
		gui_texture=load("res://assets/UI/icons/weapons/spr_Pistol.png"),
		stats= [{
			shooting_cooldown= level_stat(1, 0.1, 10)
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
			special_power_cooldown= level_stat(120, 30, 6)
		}]
	},{
		name="shotgun",
		packed_scene=preload("res://scenes/weapons/Shotgun.tscn"),
		projectile_packed_scene=preload("res://scenes/projectiles/bullet.tscn"),
		gui_texture=load("res://assets/UI/icons/weapons/ShotGun.png"),
		stats= [{
			shooting_cooldown= level_stat(2, 0.25, 7)
		}, {
			balls_by_burt= level_stat(3, 12, 8)
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
			special_power_cooldown= level_stat(120, 30, 6)
		}]
	},{
		name="mini_uzi",
		packed_scene=preload("res://scenes/weapons/MiniUzi.tscn"),
		projectile_packed_scene=preload("res://scenes/projectiles/bullet.tscn"),
		gui_texture=load("res://assets/UI/icons/weapons/MiniUzi.png"),
		stats= [{
			shooting_cooldown= level_stat(0.2, 0.1, 5)
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
			special_power_cooldown= level_stat(120, 30, 6)
		}]
	},{
		name="riffle",
		packed_scene=preload("res://scenes/weapons/Riffle.tscn"),
		projectile_packed_scene=preload("res://scenes/projectiles/bullet.tscn"),
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
			special_power_cooldown= level_stat(120, 30, 6)
		}]
	},{
		name="machine_gun",
		packed_scene=preload("res://scenes/weapons/MachineGun.tscn"),
		projectile_packed_scene=preload("res://scenes/projectiles/bullet.tscn"),
		gui_texture=load("res://assets/UI/icons/weapons/BigMachineGun.png"),
		stats= [{
			shooting_cooldown= level_stat(0.5, 0.1, 5)
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
			special_power_cooldown= level_stat(120, 30, 6)
		}]
	},{
		name="grenade_launcher",
		packed_scene=preload("res://scenes/weapons/GrenadeLauncher.tscn"),
		projectile_packed_scene=preload("res://scenes/projectiles/grenade.tscn"),
		gui_texture=load("res://assets/UI/icons/weapons/GrenadeLauncher.png"),
		stats= [{
			shooting_cooldown= level_stat(1, 0.1, 10)
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
		}]
	},{
		name="sniper",
		packed_scene=preload("res://scenes/weapons/Sniper.tscn"),
		projectile_packed_scene=preload("res://scenes/projectiles/bullet.tscn"),
		gui_texture=load("res://assets/UI/icons/weapons/Sniper.png"),
		stats= [{
			shooting_cooldown= level_stat(1.5, 0.25, 6)
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
			special_power_cooldown= level_stat(120, 30, 6)
		}, {
			auto_lock_target= level_stat(false, true, 1)
		}]
	},
]

var all_knife_scene_list = [
	{
		name="knife",
		packed_scene=preload("res://scenes/weapons/Knife.tscn"),
	}
]

var all_passive_effect_scene_list = [
#	{
#		name="health",
#		packed_scene=preload("res://scenes/PassiveEffects/HealthEffect.tscn"),
#	},{
#		name="speed",
#		packed_scene=preload("res://scenes/PassiveEffects/SpeedEffect.tscn"),
#	},{
#		name="slow_down",
#		packed_scene=preload("res://scenes/PassiveEffects/SlowDownEffect.tscn"),
#	},{
#		name="damage",
#		packed_scene=preload("res://scenes/PassiveEffects/DamageEffect.tscn"),
#	},
]
