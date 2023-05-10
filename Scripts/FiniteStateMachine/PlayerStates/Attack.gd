extends PlayerState

@export var attackImpulse = 1.0
@export var scaler = 1.4
@export var seconds = 0.1
var hitCounter = 0

func enter(_msj := {}):
	pass

func perform_update(delta):
	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")

func perform_physics_update(delta):

	attack()

func attack():

	entity.animationTree.set("parameters/FirstAttack/blend_position", entity.attackDirection)
	entity.animationTree.set("parameters/SecondAttack/blend_position", entity.attackDirection)

	entity.sprite.flip(entity.attackDirection)
	
		# Attack Logic
	var closeEnemy = entity.sensor.find_closest_enemy()
	var distance = 0
	if closeEnemy != null:
		distance = entity.global_position.distance_to(closeEnemy.global_position)

	#Modificar que la velocidad se vea afectada tambien con que tal cerca estamos
	if entity.attack_redirect:
		if !entity.attacked:
			entity.attacked = true
			entity.attack_adjusment()
		if entity.gap_closer_attack:
			entity.attack_impulse_distance(distance)
		else:
			entity.animationTree.advance(entity.attackAnimSpeed)

	#stop behaviour at hitting
	if !entity.combatSystem.hitbox.hitted:
		if entity.attackingFromDinstance:
			entity.movement.impulse(entity.impulseDirection.normalized() * distance * entity.attackScaler) #mantener con input_vector
		else:
			if closeEnemy:
				entity.movement.impulse(entity.impulseDirection.normalized() * distance * 1.4) #mantener con input_vector
				await get_tree().create_timer(seconds).timeout
				entity.movement.stop_movement() #mantener con input_vector
			else:
				entity.movement.impulse(entity.impulseDirection.normalized() * attackImpulse) #mantener con input_vector
				# await get_tree().create_timer(seconds).timeout
				# entity.movement.stop_movement() #mantener con input_vector

	elif entity.combatSystem.hitbox.hitted:
		if entity.attackingFromDinstance:
			entity.movement.impulse(entity.impulseDirection.normalized() * -entity.knockback_strenght)
			entity.combatSystem.slowMotion.start_slow_motion()
		else:
			entity.movement.impulse(entity.attackDirection.normalized() * -2)
			# entity.combatSystem.slowMotion.start_slow_motion()