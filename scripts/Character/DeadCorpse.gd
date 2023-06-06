extends Node2D
class_name Corpse


enum CorpseType {
  POLICE,
  CARTEL,
}

@onready var sprite_cartel1 = $SpriteCartel1
@export var array_tiles_cartel1 : Array[Rect2] = [
	Rect2(70, 20, 52, 29),
	Rect2(69, 88, 53, 22),
	Rect2(68, 152, 54, 24),
	Rect2(66, 219, 51, 24),
	Rect2(68, 282, 39, 23),
	Rect2(64, 414, 51, 22),
	Rect2(66, 476, 57, 19),
	Rect2(65, 544, 57, 19),
	Rect2(75, 729, 43, 26)
]

@onready var sprite_police = $SpritePolice
@export var array_tiles_police : Array[Rect2] = [
	Rect2(76, 17, 37, 37),
	Rect2(75, 79, 46, 30),
	Rect2(75, 144, 49, 25),
	Rect2(68, 208, 52, 25),
	Rect2(70, 275, 58, 22),
	Rect2(78, 338, 43, 27),
	Rect2(8, 85, 52, 29),
	Rect2(3, 144, 51, 33),
	Rect2(0, 407, 63, 26),
	Rect2(2, 606, 61, 25),
	Rect2(10, 799, 46, 30),
	Rect2(3, 852, 50, 50),
	Rect2(395, 21, 48, 21),
	Rect2(522, 24, 51, 22),
	Rect2(653, 24, 60, 18),
	Rect2(717, 13, 54, 26),
	Rect2(850, 14, 54, 27),
	Rect2(409, 186, 52, 21),
	Rect2(538, 187, 51, 24),
	Rect2(602, 187, 58, 20),
	Rect2(670, 185, 39, 23),
	Rect2(800, 184, 46, 18),
]

var type : CorpseType = CorpseType.CARTEL

func _ready():
	randomize()


func display_corpse():
	if type == CorpseType.CARTEL:
		sprite_cartel1.visible = true
		sprite_police.visible = false
		sprite_cartel1.region_rect = array_tiles_cartel1[randi()%array_tiles_cartel1.size()]
	elif type == CorpseType.POLICE:
		sprite_cartel1.visible = false
		sprite_police.visible = true
		sprite_police.region_rect = array_tiles_police[randi()%array_tiles_police.size()]
	
	#sprite.global_position.x = rect.size.x	
	
