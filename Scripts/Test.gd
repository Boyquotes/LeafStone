extends Node2D


var idledown = preload("res://Animations of the character -Sheet.png")

onready var animationTree = $AnimationTree
onready var sprite = $Sprite
onready var playback = animationTree.get("parameters/playback")

func _ready():
	# sprite.texture = idledown
	animationTree.active = true
	playback.travel("Run Right")

func _process(delta):
	
	if Input.is_action_just_pressed("attack"):
		sprite.texture = idledown