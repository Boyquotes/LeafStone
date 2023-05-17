extends PlayerState

@export var attackImpulseWhenNoEnemies = 20
@export var scaler = 1.4
@export var seconds = 0.1
var hitCounter = 0
var atDistance: bool

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
	# var closeEnemy = entity.sensor.find_closest_body()
	var distance = 0
	if entity.sensor.target != null:
		distance = entity.sensor.get_target_distance()

	if entity.attack_redirect:
		if !entity.attacked: #if havent adjust the attack, then adjust and mark it as true to avoid repeating.
			entity.attacked = true
			entity.attack_adjusment()
		else:
			entity.animationTree.advance(entity.attackAnimSpeed)

	#En caso de no golpear.
	if !entity.combatSystem.hitbox.hitted:
		if entity.facing:
			entity.movement.impulse(entity.impulseDirection.normalized() * distance * scaler)
					
			await get_tree().create_timer(seconds).timeout
			entity.movement.stop_movement() 
			
		else: #Si no hay enemigo en el area entonces se procede a no avanzar mucho.
			entity.movement.impulse(entity.impulseDirection.normalized() * attackImpulseWhenNoEnemies)

	#En caso de golpear.
	elif entity.combatSystem.hitbox.hitted:
		entity.movement.impulse(entity.attackDirection.normalized() * -2)

func exit():
	entity.attacked = false
