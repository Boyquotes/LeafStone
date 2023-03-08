extends Area2D
class_name Hurtbox

var stats : Stats
var knockBack_vector = Vector2.ZERO
var something_hitted = false
@onready var audioSource = $SFX

func setup(stat: Stats):
	self.stats = stat

func take_damage(area: Area2D, damage: float, sound: AudioStream, knockBack_vec: Vector2):
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
