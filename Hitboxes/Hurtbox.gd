extends Area2D
class_name Hurtbox

var stats : Stats
var knockBack_vector = Vector2.ZERO
var something_hitted = false
@onready var audioSource = $SFX

func setup(stat: Stats):
	self.stats = stat

func take_damage(damage: float, sound: AudioStream, knockBack_vec: Vector2):
	# Engine.time_scale = 1
	stats.set_health(-damage)
	knockBack_vector = knockBack_vec
	something_hitted = true
	play(sound)

func play(sound: AudioStream):
	if sound != null:
		audioSource.performSoundOnce(sound)	

func disable_monitoring_and_monitorable():
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)

##Enables or disable monitoring and monitorable depending on the value based on true or false.
func set_monitoring_and_monitorable(value: bool):
	set_deferred("monitoring", value)
	set_deferred("monitorable", value)