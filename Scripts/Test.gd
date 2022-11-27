extends Node2D

onready var jester = $Buffon
onready var paladin = $Paladin
var distance
var sqrDistance 

var powX
var powY

func _ready():
	
	powX = paladin.global_position.x - jester.global_position.x
	powY = paladin.global_position.y - jester.global_position.y
	sqrDistance = sqrt(pow(powX, 2) + pow(powY, 2))
	distance = paladin.global_position.distance_to(jester.global_position)
	print("Distance To: " + str(distance))
	print("sqrDistance:" +str(sqrDistance))

