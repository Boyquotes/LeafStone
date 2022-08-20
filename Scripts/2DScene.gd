extends Node2D

onready var sprite1 = $Sprite
onready var sprite2 = $Sprite2

func _ready():
	pass

func _process(delta):
	var distance = sprite1.global_position.distance_to(sprite2.global_position)
	print(str(distance))
	pass
