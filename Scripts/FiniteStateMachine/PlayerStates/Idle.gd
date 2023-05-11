#idle.gd
extends PlayerState

func enter(_msg := {}) -> void:
	entity.movement.stop_movement()
	entity.playback.travel("Idle")
	#Continue with the code from here.

func perform_update(_delta: float) -> void:

	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")

	if entity.playback.get_current_node() != "FirstAttack" or entity.playback.get_current_node() != "SecondAttack":
		
		if entity.combatSystem.stats.is_dead() and entity.playback.get_current_node() == "Hurt":
			return

		if Input.is_action_just_pressed("attack"):
			state_machine.transition_to("Attack") 
			if entity.secondAttack == 0:
				entity.playback.travel("FirstAttack")
			elif entity.secondAttack == 1:
				entity.playback.travel("SecondAttack")

func perform_physics_update(_delta: float) -> void:
	
	entity.movement.stop_movement()

	if entity.input_vector != Vector2.ZERO:
		state_machine.transition_to("Run")

