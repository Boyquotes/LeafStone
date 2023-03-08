#idle.gd
extends PlayerState

func enter(_msg := {}) -> void:
	player.movement.stop_movement()
	#Continue with the code from here.

func perform_update(_delta: float) -> void:
	if player.animationTreePlayback.get_current_node() != "FirstAttack" or player.animationTreePlayback.get_current_node() != "SecondAttack":
		
		if player.combatSystem.stats.is_dead() and player.animationTreePlayback.get_current_node() == "Hurt":
			return

		if Input.is_action_just_pressed("attack"):
			state_machine.transition_to("Attack") 
			if player.secondAttack == 0:
				player.animationTreePlayback.travel("FirstAttack")
			elif player.secondAttack == 1:
				player.animationTreePlayback.travel("SecondAttack")

func perform_physics_update(_delta: float) -> void:
	
	# player.firstMove = false
	player.animationTreePlayback.travel("Idle")
	player.movement.stop_movement()

	if player.input_vector != Vector2.ZERO:
		state_machine.transition_to("Run")

