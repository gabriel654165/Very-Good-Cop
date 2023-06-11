extends Node
class_name LevelDifficulty

var player_ref : Player
var minimap_ref : Minimap
var average_level_time : float = 0.

#time for 1 enemy in room : 10s
#time for 2 enemy in room : 10s * 2
var time_for_one_enemy : float = 5.
var time_for_one_room : float = 3.

var money_by_kill : float = 50
var money_by_room_cleared : float = 150
var money_by_power_up : float = 30


func init(player: Player, minimap: Minimap):
	player_ref = player
	minimap_ref = minimap

func calculate_money_bonus(rooms_cleared: int, kills_done: int, power_up_taken: int) -> float:
	var rooms_cleared_money = money_by_room_cleared * rooms_cleared 
	var kills_money = money_by_kill * kills_done
	var power_up_money = money_by_power_up * power_up_taken
	
	return rooms_cleared_money + kills_money + power_up_money
	

func update_difficulty():
	if player_ref == null or minimap_ref == null:
		return
	
	var new_room_enemy_array = minimap_ref.get_room_enemies_pos_list()
	
	average_level_time += time_for_one_room
	average_level_time += time_for_one_enemy * new_room_enemy_array.size()
	
