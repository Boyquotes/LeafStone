extends KinematicBody2D

var moveDirection = Vector2.ZERO
export var speed = 35
export var acceleration = 45
export var friction = 100
export var knockback_strenght = 100
var knockBack_vector = Vector2()

#components
onready var hurtbox = $HurtBox
onready var slimeStats = $Stats
onready var slimeHitbox = $SlimeHitbox
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var playback = animationTree.get("parameters/playback")
onready var label = $Node2D/Panel/Label
onready var chaseTimer = $ChaseTimer
onready var attackTimer = $AttackTimer
onready var softCollisions = $SoftCollision2D


#IA Variables
enum {idle, wander, chase, hurt, attack, dead }
var behaviour_states = idle
var behaviour_text_debug = ""

#IA Attack Variables
export var secToAttack = 8
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
	Main.setTimeOut(secToAttack)
	animationTree.active = true
	slimeHitbox.slimeStats = slimeStats
	hurtbox.stats = slimeStats
	secondsToChase = rng.randf_range(0.1, 0.1)
	secToAttack = rng.randf_range(1.0, 3.0)


func _process(delta):

	label.text = behaviour_text_debug
	slimeStats.behaviour_states = behaviour_states
	
func _physics_process(delta):

	if(player != null):
		playerDistance = mesureDIstance()

	decisionMaking(playerDistance)

	match behaviour_states:

		chase:
			behaviour_text_debug = "chase"
			$Sprite.flip_h = playerDir.x < 0
			playback.travel("Walk")
			
			if timeToChase:
				if playerDistance > 700:
					moveDirection = moveDirection.move_toward(playerDir * speed, 50 * delta)
					moveDirection = move_and_slide(moveDirection)

				elif playerDistance < 700:
					moveDirection = moveDirection.move_toward(Vector2.ZERO, friction * delta)
					moveDirection = move_and_slide(moveDirection)

			else: #Si no es tiempo de chase, entonces: 
				moveDirection = moveDirection.move_toward(Vector2.ZERO, 500 * delta)
				moveDirection = move_and_slide(moveDirection)
		attack:
			
			attackTimer.start(secToAttack)
			chaseTimer.start(secondsToChase)
			behaviour_text_debug = "attack"
			playback.travel("Attack")
			

			if moveDirection == Vector2.ZERO:
				moveDirection = attackDirection * 20
				return

			moveDirection = moveDirection.move_toward(attackDirection * 50, 55 * delta)
			moveDirection = move_and_slide(moveDirection)

		idle:
			behaviour_text_debug = "idle"
			moveDirection = moveDirection.move_toward(Vector2.ZERO, friction * delta)
			moveDirection = move_and_slide(moveDirection)
			playback.travel("Idle")
		hurt:
			# $SlimeHitbox/CollisionShape2D.set_deferred("disabled", true)
			behaviour_text_debug = "hurt"
			playback.travel("Hurt")
			moveDirection = hurtbox.knockBack_vector * knockback_strenght
			moveDirection = move_and_slide(moveDirection)
		dead:
			behaviour_text_debug = "dead"
			playback.travel("Dead")
			moveDirection = moveDirection.move_toward(Vector2.ZERO, friction * delta)
			moveDirection = move_and_slide(moveDirection)

	if softCollisions.is_colliding():
		moveDirection += softCollisions.push_vector()* delta * 50
	moveDirection = move_and_slide(moveDirection)	

func decisionMaking(distance):

	if playerDetected:
		playerDir = (player.global_position - global_position).normalized()

		if slimeStats.something_hitted:
			behaviour_states = hurt
			return

		if distance <= 1200 && !slimeStats.is_dead():
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

	if slimeStats.is_dead():
		behaviour_states = dead
		return


func mesureDIstance():
	return player.global_position.distance_squared_to(global_position)

func _on_DetentionArea_body_entered(body:Node):
	$ScannerArea/CollisionShape2D.scale = Vector2(10,10)

	playerDetected = true
	player = body


func _on_DetentionArea_body_exited(body:Node):
	playerDetected = false
	player = null
	$ScannerArea/CollisionShape2D.scale = Vector2(8,8)

func when_dead():
	pass
	# queue_free()

func on_attack_finished():
	behaviour_states = idle
	shouldCount = true

func on_hurt_finished():
	behaviour_states = idle
	slimeStats.something_hitted = false

func _on_AttackTimer_timeout():
	waitAttackCompleted = true


func _on_ChaseTimer_timeout():
	timeToChase = true


func _on_Stats_Dead():
	$HurtBox.monitorable = false
	$HurtBox.monitoring = false
	$SlimeHitbox.monitoring = false
	$SlimeHitbox.monitorable = false
