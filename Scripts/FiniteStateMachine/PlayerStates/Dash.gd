#dash.gd
extends PlayerState

@export var cooldown = 4

func enter(_msg := {}) -> void:
	entity.playback.travel("Dash")
	
	var dashLenght = entity.playback.get_current_length()
	entity.combatSystem.stats.set_invincible(dashLenght)

func perform_physics_update(delta: float) -> void:

	entity.movement.impulse(entity.attackDirection.normalized() * 115) #140

	if Input.is_action_just_pressed("attack") or entity.attackPressed: 
		entity.attackPressed = false
		entity.playback.stop()
		entity.attackAnimSpeed = 0.2