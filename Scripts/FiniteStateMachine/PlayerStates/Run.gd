# Run.gd
extends PlayerState

@export var runSFX : AudioStream

func enter(_msg := {}) -> void:
	entity.combatSystem.hitbox.set_hitted_state(false)
	entity.playback.travel("Run")

func perform_update(delta: float) -> void:

	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
		
	if not entity.movement.is_moving():
		state_machine.transition_to("Idle")	

	entity.sprite.flip(entity.input_vector)

	if entity.playback.get_current_node() != "FirstAttack" or entity.playback.get_current_node() != "SecondAttack":
		if entity.combatSystem.stats.is_dead() and entity.playback.get_current_node() == "Hurt":
			return
		if Input.is_action_just_pressed("attack"): 
			state_machine.transition_to("Attack")
			if entity.secondAttack == 0:
				entity.playback.travel("FirstAttack")
			elif entity.secondAttack == 1:
				entity.playback.travel("SecondAttack")
	
func perform_physics_update(delta: float) -> void:

	entity.attackDirection = entity.input_vector.normalized()
	entity.impulseDirection = entity.input_vector.normalized()

	entity.movement.move(entity.input_vector.normalized())

