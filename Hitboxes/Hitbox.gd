extends Area2D
class_name Hitbox

var hit = false
var knockBack_vector = Vector2.ZERO
var	make_knockBack = false
var stats : Stats

@export var freeze_slow = 0.045
@export var duration = 0.3

@onready var audioSource = $SFX
@onready var shape = $Shape
@onready var slowMotion: Node = $SlowMotion

func setup(stat: Stats):
	self.stats = stat

func disable_collision(value):
	shape.set_deferred("disabled", value)

func play(sound: AudioStream):
	if sound != null:
		audioSource.performSoundOnce(sound)

func disable_monitoring_and_monitorable():
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)

func active(value: bool):
	if value == true:
		shape.set_deferred("disabled", false)
	elif value == false:
		shape.set_deferred("disabled", true)

func doSlowMotion():
	slowMotion.start_slow_motion()