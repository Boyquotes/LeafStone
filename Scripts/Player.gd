class_name Player
extends CharacterBody2D

#Attack adjustment.
@export var attack_redirect = false
@export var gapcloser_attack = false
@export var attackScaler := 4.0
@export var closeAttack = 50
@export var maxRangedAttack = 160
@export var defaultAttackImpulse = 30
var facing = false
var attacked = false #Controls the attack adjusment happen just once.
var secondAttack = 0

@export var cooldown: float = 2.0
@export var max_speed = 38
@export var attackImpulse = 100
@export var sound : AudioStream

var dashReady = true
var attackPressed = false
var dashPressed = false

enum behaviours {idle, run, attack, stunned, dash, dead, hurt}
var state = behaviours.idle
var current_state = "idle"

var attackAnimSpeed = 0.2
var attackingFromDinstance = false

@onready var movement : Movement = $Movement
@onready var combatSystem = $CombatSystem
@onready var bodyshape = $BodyShape
@onready var sprite = $Sprite2D
@onready var sensor = $Sensor

#Animation Variables
@onready var animationTree = $AnimationTree
@onready var animationPlayer = $AnimationPlayer
@onready var animationTreePlayback = animationTree.get("parameters/playback")
@export var input_vector: Vector2
var attackDirection = Vector2(1,1)
var impulseDirection = Vector2.ZERO

var timerExtended = preload("res://Scenes/ExtendedTimer.tscn")
@onready var extended = timerExtended.instantiate()
@onready var extended2 = timerExtended.instantiate()

func _ready():
	movement.setup(self)
	animationTree.active = true

	add_child(extended)
	add_child(extended2)

func set_Run(): 
	state = behaviours.run

func set_Dash_True():
	dashReady = true		

func _process(_delta):
	current_state = behaviours.keys()[state]		

	if Input.is_action_just_pressed("ui_accept"):
		combatSystem.stats.set_health(12)

	if (Input.is_action_just_pressed("dash") or dashPressed) and dashReady:
		dashPressed = false
		state = behaviours.dash
	
	if animationTreePlayback.get_current_node() != "attack" or animationTreePlayback.get_current_node() != "attack2":
		if combatSystem.stats.is_dead() and animationTreePlayback.get_current_node() == "hurt":
			return

		if Input.is_action_just_pressed("attack") or attackPressed: 
			attackPressed = false
			if secondAttack == 0:
				animationTreePlayback.travel("FirstAttack")
			elif secondAttack == 1:
				animationTreePlayback.travel("SecondAttack")
					
func _physics_process(delta):
	input_vector = Vector2.ZERO	
	input_vector.x = Input.get_axis("move_left", "move_right")
	input_vector.y = Input.get_axis("move_up", "move_down")

	combatSystem.hitbox.knockBack_vector = attackDirection.normalized()

	if combatSystem.stats.is_dead():
		state = behaviours.dead

	if !combatSystem.stats.is_dead():
		if state != behaviours.attack:
			sprite.flip(input_vector)

		if animationTreePlayback.get_current_node() != "attack":
			set_velocity(velocity)
			move_and_slide()
			velocity = velocity

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

func hurt_state():

	movement.impulse(impulseDirection.normalized() * 55)
	animationTreePlayback.travel(current_state)
	
	$SlowMotion.start_slow_motion()

func attack_adjusment():
	var values = $Sensor.find_closest_enemy_angle(attackDirection)

	if values != null:
		var enemyDir = values["enemyDir"]
		var angle = values["angle"]

		var savedDir = attackDirection
		if combatSystem.hitbox.hit == false:
			if angle > 0 and angle < 45:
				facing = true
				attackDirection = enemyDir
				impulseDirection = enemyDir
			else:
				facing = false
				attackDirection = savedDir
				impulseDirection = savedDir

func attack_animation_finished():
	$StateMachine.transition_to("Idle")
	attackAnimSpeed = 0.2
	attackingFromDinstance = false
	attacked = false
	facing = false
	
	if secondAttack == 0:
		secondAttack = 1
	elif secondAttack == 1:
		secondAttack= 0

func _on_Stats_Damaged(amount):
	animationTreePlayback.stop()
	state = behaviours.hurt
	combatSystem.stats.set_invincible(true, 2)

func attackSpeed():	
	attackAnimSpeed = 0

func _on_Stats_Dead():
	combatSystem.hurtbox.disable_monitoring_and_monitorable()
	combatSystem.hitbox.monitoring = false
	bodyshape.set_deferred("disabled", true)

func _on_AttackTsch_pressed():
	attackPressed = true

func _on_DashTsch_pressed():
	dashPressed = true
