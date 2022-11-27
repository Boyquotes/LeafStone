extends Area2D

var knockBack_vector = Vector2.ZERO
var playerStats
var hitted = false
var	make_knockBack = false
var berserk = false
var berserkCount = 0
onready var hitSource = $AudioSource

export var freeze_slow = 0.045
export var freeze_time = 0.3

func Hit(_area):
	pass
	# if !hitSource.playing:
	# 	hitSource.play()
	
	Engine.time_scale = freeze_slow
	yield(get_tree().create_timer(freeze_time * freeze_slow), "timeout")
	Engine.time_scale = 1

func _on_Hitbox_area_entered(area:Area2D):

	area.stats.set_health(-playerStats.damage)
	area.stats.something_hitted = true
	area.knockBack_vector = knockBack_vector.normalized()
	hitted = true
	make_knockBack = true
	Hit(area)
