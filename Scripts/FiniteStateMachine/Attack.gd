extends PlayerState

func enter(_msj := {}):

	#Connect to animation finished in order to transition when the current animation is done.
	#One action(Attack and Dash) got affected with this aproach because its transition to Idle When Attack finished
	player.animationPlayer.connect("animation_finished", func(): state_machine.transition_to("Idle"))
	
func perform_physics_update(delta):
	# firstMove = false	
	player.animationTree.set("parameters/FirstAttack/blend_position", player.attackDirection)
	player.animationTree.set("parameters/SecondAttack/blend_position", player.attackDirection)

	player.sprite.flip(player.attackDirection)
	
		# Attack Logic
	var closeEnemy = player.sensor.find_closest_enemy()
	var distance = 0
	if closeEnemy != null:
		distance = player.global_position.distance_to(closeEnemy.global_position)

	#Modificar que la velocidad se vea afectada tambien con que tal cerca estamos
	if player.attack_redirect:
		if !player.attacked:
			player.attacked = true
			player.attack_adjusment()
		if player.gapcloser_attack:
			player.attack_impulse_distance(distance)
		else:
			player.animationTree.advance(player.attackAnimSpeed)

	#stop behaviour at hitting
	if !player.combatSystem.hitbox.hit:
		if player.attackingFromDinstance:
			player.movement.impulse(player.impulseDirection.normalized() * distance * player.attackScaler) #mantener con input_vector
		else:
			Engine.time_scale = 1
			player.movement.impulse(player.impulseDirection.normalized() * player.defaultAttackImpulse) #mantener con input_vector
	else:
		if player.attackingFromDinstance:
			player.combatSystem.slowDown()
			# player.movement.impulse(player.impulseDirection.normalized() * -player.attackImpulse / 100)
			# player.movement.stop_movement()
			player.movement.impulse(player.impulseDirection.normalized() * player.attackImpulse / 100)
			player.combatSystem.hitbox.doSlowMotion()
			# await get_tree().create_timer(0.8).timeout
			# player.extended.performTimer(0.8,func(): Engine.time_scale = 1)
			# Engine.time_scale = 1
		else:
			player.movement.impulse(player.impulseDirection.normalized() * player.attackImpulse / 5)
			# player.movement.stop_movement()
