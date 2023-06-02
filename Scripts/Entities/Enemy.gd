class_name Enemy
extends Entity

var moveDirection = Vector2.ZERO
@export var speed = 35
@export var acceleration = 45
@export var friction = 100
@export var knockback_strenght = 100
@export var distace_limit : float = 60
var knockBack_vector = Vector2()

#Components
@onready var chaseTimer = $ChaseTimer
@onready var attackTimer = $AttackTimer
@onready var softCollisions = $SoftCollision
@export var attackBehaviour: AttackBehavior

#IA Variables
enum SlimeState{idle, wander, chase, hurt, attack, dead }
var enemy_state : SlimeState = SlimeState.idle

#IA Attack Variables
var secToAttack = 8
var playerDir = Vector2()
var attackDirection
var playerDistance = 0.0
var waitAttackCompleted = true

var secondsToChase = 0.7
var timeToChase = true
var rng = RandomNumberGenerator.new()

var playerDetected = false
var player = null

#Functions
func _ready():
	animationTree.active = true
	secondsToChase = rng.randf_range(0.1, 0.1)
	secToAttack = rng.randf_range(1.0, 5.0)

	attackTimer.timeout.connect(func(): waitAttackCompleted = true )
	sensor.body_entered.connect(func(body: Node): at_body_entered(body))
	sensor.body_exited.connect(func(body: Node): at_body_exited(body))

	combatSystem.onHurtBox.connect("OnEventHappen", Callable(self, "set_hurt_state"))

func _process(delta):
	pass
	
func _physics_process(delta):

	if(player != null):
		playerDistance = mesureDIstance()

	decisionMaking(playerDistance)

	match enemy_state:

		SlimeState.chase:
			sprite.flip(playerDir)
			playback.travel("Walk")
			
			if timeToChase:
				if playerDistance > distace_limit:
					moveDirection = moveDirection.move_toward(playerDir * speed, 50 * delta)
					set_velocity(moveDirection)
					move_and_slide()
					moveDirection = velocity

				elif playerDistance < distace_limit:
					moveDirection = moveDirection.move_toward(Vector2.ZERO, friction * delta)
					set_velocity(moveDirection)
					move_and_slide()
					moveDirection = velocity

			else: #Si no es tiempo de chase, entonces: 
				moveDirection = moveDirection.move_toward(Vector2.ZERO, 600 * delta)
				set_velocity(moveDirection)
				move_and_slide()
				moveDirection = velocity

		SlimeState.attack:
			attackTimer.start(secToAttack)
			chaseTimer.start(secondsToChase)
			playback.travel("Attack")

			if moveDirection == Vector2.ZERO:
				moveDirection = attackDirection * 40
				return
				
			moveDirection = moveDirection.move_toward(attackDirection * 140, 80 * delta)
			set_velocity(moveDirection)
			move_and_slide()
			moveDirection = velocity

		SlimeState.idle:
			moveDirection = moveDirection.move_toward(Vector2.ZERO, friction * delta)
			set_velocity(moveDirection)
			move_and_slide()
			moveDirection = velocity
			playback.travel("Idle")

			if softCollisions.is_colliding():
				var area = find_player()
				if area != null:
					moveDirection += softCollisions.push_vector() * delta * 350
					
		SlimeState.hurt:
			sprite.squatch()
			playback.travel("Hurt")
			moveDirection = -combatSystem.hurtbox.knockBack_vector * knockback_strenght
			set_velocity(moveDirection)
			move_and_slide()
			moveDirection = velocity

		SlimeState.dead:
			playback.travel("Dead")
			moveDirection = moveDirection.move_toward(Vector2.ZERO, friction * delta)
			set_velocity(moveDirection)
			move_and_slide()
			moveDirection = velocity
			combatSystem.set_hitbox_active_state(false)

	if softCollisions.is_colliding():
		var area = find_player()
		if area != null and enemy_state != SlimeState.attack:
			moveDirection += softCollisions.push_vector()* delta * 235

		else: moveDirection += softCollisions.push_vector() * delta * 60
		
	set_velocity(moveDirection)
	move_and_slide()
	moveDirection = velocity	

func find_player() -> CharacterBody2D:
	var areas = softCollisions.get_overlapping_bodies()
	var body
	for area in areas:
		if area.name == "Player":
			body = area

	return body	


func decisionMaking(distance):

	if combatSystem.stats.is_dead():
		enemy_state = SlimeState.dead
		return


	if playerDetected:
		playerDir = (player.global_position - global_position).normalized()

		if combatSystem.hurtbox.something_hitted:
			if playback.get_current_node() != "Hurt":
				enemy_state = SlimeState.hurt
			return	

		if distance <= 90 && !combatSystem.stats.is_dead():
			if waitAttackCompleted:
				#obtenemos la posicion del jugador solo una vez
				timeToChase = false
				waitAttackCompleted = false
				attackDirection = (player.global_position - global_position).normalized()
				enemy_state = SlimeState.attack
				return

		if enemy_state != SlimeState.attack:
			enemy_state = SlimeState.chase

	elif playerDetected == false: 
		enemy_state = SlimeState.idle

func mesureDIstance():
	return player.global_position.distance_to(global_position)

func at_body_entered(body:Node):
	sensor.shape.scale = Vector2(10,10)
	playerDetected = true
	player = body

func at_body_exited(body:Node):
	playerDetected = false
	player = null
	sensor.shape.scale = Vector2(8,8)

func when_dead():
	combatSystem.hurtbox.disable_monitoring_and_monitorable()
	combatSystem.hitbox.disable_monitoring_and_monitorable()
	set_collision_layer_value(4, false)
	await get_tree().create_timer(10).timeout
	var tween = create_tween().tween_property(sprite, "modulate", Color.TRANSPARENT, 1)
	await tween.finished
	queue_free()

func on_attack_finished():
	enemy_state = SlimeState.idle

func set_hurt_state():

	combatSystem.hurtbox.something_hitted = true
	enemy_state = SlimeState.hurt

func on_hurt_finished():
	enemy_state = SlimeState.idle
	combatSystem.hurtbox.something_hitted = false

func _on_ChaseTimer_timeout():
	timeToChase = true
