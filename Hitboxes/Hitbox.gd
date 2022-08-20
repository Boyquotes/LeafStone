extends Area2D

var knockBack_vector = Vector2.ZERO
var playerStats
var hitted = false
var	make_knockBack = false
var berserk = false
var berserkCount = 0
onready var hitSource = $AudioSource

func Hit(_area):
	if !hitSource.playing:
		hitSource.play()

func _on_Hitbox_area_entered(area:Area2D):

	Hit(area)
	area.stats.set_health(-playerStats.damage)
	area.stats.something_hitted = true
	area.knockBack_vector = knockBack_vector.normalized()
	hitted = true
	make_knockBack = true

	if area.stats.behaviour_states == area.stats.dead: #importante acceder a los posibles estados
		berserkCount += 1

		if berserkCount >= 3:
			berserk = true
			yield(get_tree().create_timer(3.0), "timeout")
			berserk = false
			berserkCount = 0
