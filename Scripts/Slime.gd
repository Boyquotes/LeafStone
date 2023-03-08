extends CharacterBody2D

var moveDirection = Vector2.ZERO
@export var speed = 35
@export var acceleration = 45
@export var friction = 100
@export var knockback_strenght = 100
var knockBack_vector = Vector2()

#components
@onready var combatSystem = $CombatSystem
@onready var sprite = $Sprite2D
@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var playback = animationTree.get("parameters/playback")
@onready var label = $Node2D/Panel/Label
@onready var chaseTimer = $ChaseTimer
@onready var attackTimer = $AttackTimer
@onready var softCollisions = $SoftCollision

#IA Variables
enum {idle, wander, chase, hurt, attack, dead }
var behaviour_states = idle
var behaviour_text_debug = ""

#IA Attack Variables
@export var secToAttack = 8
var playerDir = Vector2()
var attackDirection
var playerDistance = 0.0
var waitAttackCompleted = true

var secondsToChase = 0.7
var counter = 0.0
var timeToChase = true
var shouldCount = false
var ticker = 1/60
var rng = RandomNumberGenerator.new()

var playerDetected = false
var player = null

#Functions
func _ready():
	animationTree.active = true
	secondsToChase = rng.randf_range(0.1, 0.1)
	secToAttack = rng.randf_range(1.0, 3.0)

func _process(delta):

	# label.text = behaviour_text_debug
	combatSystem.stats.behaviour_states = behaviour_states
	
func _physics_process(delta):

	if(player != null):
		playerDistance = mesureDIstance()

	decisionMaking(playerDistance)

	match behaviour_states:

		chase:
			behaviour_text_debug = "chase"
			# $Sprite2D.flip_h = playerDir.x < 0
			sprite.flip(playerDir)
			playback.travel("Walk")
			
			if timeToChase:
				if playerDistance > 50:
					moveDirection = moveDirection.move_toward(playerDir * speed, 50 * delta)
					set_velocity(moveDirection)
					move_and_slide()
					moveDirection = velocity

				elif playerDistance < 50:
					moveDirection = moveDirection.move_toward(Vector2.ZERO, friction * delta)
					set_velocity(moveDirection)
					move_and_slide()
					moveDirection = velocity

			else: #Si no es tiempo de chase, entonces: 
				moveDirection = moveDirection.move_toward(Vector2.ZERO, 500 * delta)
				set_velocity(moveDirection)
				move_and_slide()
				moveDirection = velocity	
		attack:
			
			attackTimer.start(secToAttack)
			chaseTimer.start(secondsToChase)
			behaviour_text_debug = "attack"
			playback.travel("Attack")
			

			if moveDirection == Vector2.ZERO:
				moveDirection = attackDirection * 20
				return

			moveDirection = moveDirection.move_toward(attackDirection * 140, 55 * delta)
			set_velocity(moveDirection)
			move_and_slide()
			moveDirection = velocity

		idle:
			behaviour_text_debug = "idle"
			moveDirection = moveDirection.move_toward(Vector2.ZERO, friction * delta)
			set_velocity(moveDirection)
			move_and_slide()
			moveDirection = velocity
			playback.travel("Idle")

			if softCollisions.is_colliding():
				var area = find_player()
				if area != null:
					moveDirection += softCollisions.push_vector()* delta * 350
		hurt:
			sprite.squatch()
			behaviour_text_debug = "hurt"
			playback.travel("Hurt")
			moveDirection = combatSystem.hurtbox.knockBack_vector * knockback_strenght
			set_velocity(moveDirection)
			move_and_slide()
			moveDirection = velocity
		dead:
			behaviour_text_debug = "dead"
			playback.travel("Dead")
			moveDirection = moveDirection.move_toward(Vector2.ZERO, friction * delta)
			set_velocity(moveDirection)
			move_and_slide()
			moveDirection = velocity
			combatSystem.set_hitbox_active_state(false)

	if softCollisions.is_colliding():
		var area = find_player()
		if area != null and behaviour_states != attack:
			moveDirection += softCollisions.push_vector()* delta * 350

		else: moveDirection += softCollisions.push_vector()* delta * 50
		
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
		behaviour_states = dead
		return

	if playerDetected:
		playerDir = (player.global_position - global_position).normalized()

		if combatSystem.hurtbox.something_hitted:
			behaviour_states = hurt
			return

		if distance <= 90 && !combatSystem.stats.is_dead():
			if waitAttackCompleted:
				#obtenemos la posicion del jugador solo una vez
				timeToChase = false
				waitAttackCompleted = false
				attackDirection = (player.global_position - global_position).normalized()
				behaviour_states = attack
				return

		if behaviour_states != attack:
			behaviour_states = chase

	elif playerDetected == false: 
		behaviour_states = idle


func mesureDIstance():
	return player.global_position.distance_to(global_position)

func _on_DetentionArea_body_entered(body:Node):
	$ScannerArea/Shape.scale = Vector2(10,10)

	playerDetected = true
	player = body


func _on_DetentionArea_body_exited(body:Node):
	playerDetected = false
	player = null
	$ScannerArea/Shape.scale = Vector2(8,8)

func when_dead():
	pass
	# queue_free()

func on_attack_finished():
	behaviour_states = idle
	shouldCount = true

func on_hurt_finished():
	if !combatSystem.stats.is_dead():
		behaviour_states = idle
	combatSystem.hurtbox.something_hitted = false

func _on_AttackTimer_timeout():
	waitAttackCompleted = true


func _on_ChaseTimer_timeout():
	timeToChase = true

func _on_Stats_Dead():
	combatSystem.hurtbox.disable_monitoring_and_monitorable()
	combatSystem.slimeHitbox.disable_monitoring_and_monitorable()
