extends Node

#var current_weapon_index = 1

#Levels : not unlocked = 0
var glock_level : int = 1
var shotgun_level : int = 0
var mini_uzi_level : int = 0
var riffle_level : int = 0
var machine_gun_level : int = 0
var grenade_launcher_level : int = 0
var sniper_level : int = 0

var knife_level : int = 1

var grappling_hook_level : int = 1
var bulletproof_vest_level : int = 0

var index_weapon_selected : int = 0
var index_knife_selected : int = 0

var all_weapon_scene_list = [
	{
		name="glock",
		packed_scene=preload("res://scenes/weapons/Glock.tscn"),
	},{
		name="shotgun",
		packed_scene=preload("res://scenes/weapons/Shotgun.tscn"),
	},{
		name="mini_uzi",
		packed_scene=preload("res://scenes/weapons/MiniUzi.tscn"),
	},{
		name="riffle",
		packed_scene=preload("res://scenes/weapons/Riffle.tscn"),
	},{
		name="machine_gun",
		packed_scene=preload("res://scenes/weapons/MachineGun.tscn"),
	},{
		name="grenade_launcher",
		packed_scene=preload("res://scenes/weapons/GrenadeLauncher.tscn"),
	},{
		name="sniper",
		packed_scene=preload("res://scenes/weapons/Sniper.tscn"),
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
