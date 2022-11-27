extends KinematicBody2D

export var attackScaler := 4.0
export var useDistanceAttack = false
export var closeAttack = 50
export var maxRangedAttack = 160
export var defaultAttackImpulse = 30
var facing = false
var attack_one = false
export var adjust = false
var secondAttack = 0

export(float) var cooldown = 2.0
var velocity = Vector2.ZERO
export var max_speed = 35
export var attackImpulse = 100
export (AudioStream) var sound
export (AudioStream) var attackSound
onready var soundSource = $SoundSource

var dashReady = true
var attackPressed = false
var dashPressed = false

enum behaviours {idle, run, attack, stunned, dash, dead, hurt}
var state = behaviours.idle
var current_state = "idle"

var attackAnimSpeed = 0.2
var attackingFromDinstance = false

#Animation Variables
onready var animationTree = $AnimationTree
onready var stateMachine = animationTree.get("parameters/playback")

onready var playerStats = $Stats
onready var hurtbox = $HurtBox
onready var hitbox = $Hitbox

var firstMove = false
onready var movement = $Movement
var attackDirection = Vector2(1,1)
var impulseDirection = Vector2.ZERO
var timerExtended = preload("res://Scenes/ExtendedTimer.tscn")
onready var extended = timerExtended.instance()
onready var extended2 = timerExtended.instance()

func _ready():
	movement.setMovement(self)

	hitbox.playerStats = playerStats
	hurtbox.stats = playerStats
	animationTree.active = true
	soundSource.playing = true
	$Hitbox/Shape.set_deferred("disabled", true)

	add_child(extended)
	add_child(extended2)
	
func set_Run():
	state = behaviours.run

func set_Dash_True():
	dashReady = true

func _process(_delta):
	current_state = behaviours.keys()[state]		
	

	if Input.is_action_just_pressed("ui_accept"):
		playerStats.set_health(12)

	if (Input.is_action_just_pressed("Dash") or dashPressed) and dashReady:
		dashPressed = false
		state = behaviours.dash
	
	if stateMachine.get_current_node() != "attack" or stateMachine.get_current_node() != "attack2":
		if playerStats.is_dead() and stateMachine.get_current_node() == "hurt":
			return

		if Input.is_action_just_pressed("attack") or attackPressed: 
			attackPressed = false
			state = behaviours.attack
			if secondAttack == 0:
				stateMachine.travel("attack")
			elif secondAttack == 1:
				stateMachine.travel("attack2")
					

func _physics_process(delta):

	var input_vector = Vector2.ZERO	
	input_vector.x = Input.get_axis("ui_left", "ui_right")
	input_vector.y = Input.get_axis("ui_up", "ui_down")

	velocity = input_vector.normalized()

	hitbox.knockBack_vector = attackDirection.normalized()

	if playerStats.is_dead():
		state = behaviours.dead

	match state:

		behaviours.idle:
			idle_state()

		behaviours.run:
			run_state(input_vector)

		behaviours.attack:
			attack_state()

		behaviours.dash:
			dash_state()

		behaviours.hurt:
			hurt_state()

		behaviours.dead:
			movement.stop_movement()
			rotation_degrees = 90

	if !playerStats.is_dead():
		_spriteRotation(input_vector)

		if stateMachine.get_current_node() != "attack":
			velocity = move_and_slide(velocity)
		
func idle_state():
	firstMove = false
	stateMachine.travel(current_state)
	soundSource.stop()
	movement.move(Vector2.ZERO)

	if velocity != Vector2.ZERO:
		state = behaviours.run

func run_state(input_vector: Vector2):
	stateMachine.travel(current_state)
	hitbox.hitted = false
	soundSource.performSound(sound)

	if input_vector != Vector2.ZERO:
		attackDirection = input_vector.normalized()
		impulseDirection = input_vector.normalized()

	if !firstMove:
		firstMove = true
		max_speed = 1
		var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(self,"max_speed", 38, 0.16).set_ease(Tween.EASE_OUT_IN)

	movement.move(input_vector * max_speed)

	if velocity == Vector2.ZERO:
		state = behaviours.idle

func attack_state():
	firstMove = false

	soundSource.performSoundOnce(attackSound)

	animationTree.set("parameters/attack/blend_position", attackDirection)
	animationTree.set("parameters/attack2/blend_position", attackDirection)

	print(str(secondAttack))
	_spriteRotation(attackDirection)
	
		# Attack Logic
	var closeEnemy = $Sensor.find_closest_enemy()
	var distance = 0
	if closeEnemy != null:
		distance = global_position.distance_to(closeEnemy.global_position)

	#Modificar que la velocidad se vea afectada tambien con que tal cerca estamos
	if adjust:
		if !attack_one:
			attack_one = true
			attack_adjusment()
		if useDistanceAttack:
			attack_impulse_distance(distance)
		else:
			pass
			animationTree.advance(attackAnimSpeed)

	#stop behaviour at hitting
	if !hitbox.hitted:
		if attackingFromDinstance:
			movement.impulse(impulseDirection.normalized() * distance * attackScaler) #mantener con input_vector
		else:
			Engine.time_scale = 1
			movement.impulse(impulseDirection.normalized() * defaultAttackImpulse) #mantener con input_vector
	else:
		if attackingFromDinstance:
			Engine.time_scale = 0.35
			movement.impulse(impulseDirection.normalized() * -attackImpulse / 70)
			yield(get_tree().create_timer(0.8), "timeout")
			Engine.time_scale = 1
		else:
			movement.impulse(impulseDirection.normalized() * attackImpulse / 5)


func attack_impulse_distance(distance):

	var in_Distance_Range = (distance >= closeAttack and distance < maxRangedAttack)
	if (in_Distance_Range):
		if facing: #Solo si ve al jugador ataque lento y avance
			animationTree.advance(attackAnimSpeed)
			attackingFromDinstance = true
		else: #Si no ve al jugador velocidad de ataque normal sin avance
			animationTree.advance(attackAnimSpeed)
			attackingFromDinstance = false
	
	#Checar "AttackingFromDistance" que la animaciion cambie la velocidad a corta distancia.
	elif distance < closeAttack and !attackingFromDinstance:
		attackingFromDinstance = false
		animationTree.advance(attackAnimSpeed)
	elif distance > maxRangedAttack and !attackingFromDinstance:
		attackingFromDinstance = false
		animationTree.advance(attackAnimSpeed)

func dash_state():
	Engine.time_scale = 1
	stateMachine.travel(current_state)
	dashReady = false
	movement.impulse(impulseDirection.normalized() * 140)
	var animDashDuration = stateMachine.get_current_length()
	playerStats.set_invincible(true, animDashDuration)

	extended.performTimer(animDashDuration, funcref(self, "set_Run"))
	extended2.performTimer(animDashDuration,funcref(self, "set_Dash_True"))


	if Input.is_action_just_pressed("attack") or attackPressed: 
		attackPressed = false
		state = behaviours.attack
		attack_one = false
		stateMachine.stop()
		attackAnimSpeed = 0.2

func hurt_state():

	movement.impulse(impulseDirection.normalized() * 55)
	stateMachine.travel(current_state)

	Engine.time_scale = 0.45
	yield(get_tree().create_timer(0.25 * 0.45), "timeout")
	Engine.time_scale = 1

func attack_adjusment():
	var values = $Sensor.find_closest_enemy_angle(attackDirection)

	if values != null:
		var enemyDir = values["enemyDir"]
		var angle = values["angle"]
		# enemy = values["enemy"]

		var savedDir = attackDirection
		if hitbox.hitted == false:
			if angle > 0 and angle < 45:
				facing = true
				attackDirection = enemyDir
				impulseDirection = enemyDir
			else:
				facing = false
				attackDirection = savedDir
				impulseDirection = savedDir

func _spriteRotation(input_direction):

	if stateMachine.get_current_node() != "attack":
		if input_direction.x > 0: 
			$Sprite.flip_h = false #Derecha
		elif input_direction.x < 0:
			$Sprite.flip_h = true #izquierda flip

func attack_animation_finished():
	state = behaviours.idle
	attackAnimSpeed = 0.2
	attackingFromDinstance = false
	attack_one = false
	facing = false
	
	if secondAttack == 0:
		secondAttack = 1
	elif secondAttack == 1:
		secondAttack= 0

func _on_Stats_Damaged(amount):
	stateMachine.stop()
	state = behaviours.hurt
	playerStats.set_invincible(true, 2)

func attackSpeed():	
	attackAnimSpeed = 0

func _on_Stats_Dead():
	$HurtBox.monitorable = false
	$HurtBox.monitoring = false
	$Hitbox.monitoring = false
	$DetentionArea.monitoring = false
	$BodyShape.set_deferred("disabled", true)

func _on_AttackTsch_pressed():
	attackPressed = true

func _on_DashTsch_pressed():
	dashPressed = true
