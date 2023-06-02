extends Node2D

@onready var sprite = $Sprite2D

var array_tiles : Array[Rect2] = [
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

func _ready():
	randomize()
	var rect : Rect2 = array_tiles[randi()%array_tiles.size()]
	
	sprite.region_rect = rect
	
	sprite.global_position.x = rect.size.x

