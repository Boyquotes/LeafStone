# Run.gd
extends PlayerState

func enter(_msg := {}) -> void:
	
	player.combatSystem.hitbox.hit = false

func perform_update(delta: float) -> void:

	if not player.movement.is_moving():
		state_machine.transition_to("Idle")	

	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")

	# if Input.is_action_just_pressed("attack"):
	# 	state_machine.transition_to("Attack")
	if player.animationTreePlayback.get_current_node() != "FirstAttack" or player.animationTreePlayback.get_current_node() != "SecondAttack":
		if player.combatSystem.stats.is_dead() and player.animationTreePlayback.get_current_node() == "Hurt":
			return
		if Input.is_action_just_pressed("attack"): 
			state_machine.transition_to("Attack")
			if player.secondAttack == 0:
				player.animationTreePlayback.travel("FirstAttack")
			elif player.secondAttack == 1:
				player.animationTreePlayback.travel("SecondAttack")
	
func perform_physics_update(delta: float) -> void:

	player.animationTreePlayback.travel("Run")

	if player.movement.is_moving():
		player.attackDirection = player.input_vector.normalized()
		player.impulseDirection = player.input_vector.normalized()

	player.movement.move(player.input_vector.normalized())
