@tool
extends Area2D
class_name Hitbox

var hitted = false
var knockBack_vector = Vector2.ZERO
var stats : Stats

@onready var audioSource = $SFX
@onready var shape = $Shape

func setup(stat: Stats):
	self.stats = stat

func play(sound: AudioStream):
	if sound != null:
		audioSource.performSoundOnce(sound)

func set_hitted_state(value: bool):
	hitted = value

func disable_monitoring_and_monitorable():
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)

func active(value : bool):
	if value == true:
		shape.set_deferred("disabled", false)
	elif value == false:
		shape.set_deferred("disabled", true)