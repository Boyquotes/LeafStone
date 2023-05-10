extends Node2D

@export var gravity = Vector2(0,0.2)
@export var mass = 200
var velocity = Vector2(0, -1)

@export var secondsToTween = 0.2

@onready var lable = $Label
var tween : Tween

func _ready():
	lable.scale = Vector2(0.3,0.3)
	tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(lable, "scale", Vector2(0.8, 0.8), secondsToTween)
	tween.tween_property(lable, "scale", Vector2(0.4, 0.4), secondsToTween)
	tween.tween_callback(queue_free)

func set_text(value):
	lable.text = str(value)

func _process(delta):
	velocity += gravity * mass * delta
	position += velocity * delta