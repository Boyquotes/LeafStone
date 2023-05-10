class_name Player
extends Entity

#Attack adjustment.
@export var wait_after_Attack = 0.3
@export var attack_redirect = false
@export var gap_closer_attack = false
@export var attackScaler := 4.0
@export var closeAttack = 50
@export var maxRangedAttack = 160
@export var defaultAttackImpulse = 30
@export var knockback_strenght = 30
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

var attackAnimSpeed = 0.2
var attackingFromDinstance = false

@export var input_vector: Vector2
var attackDirection = Vector2(1,1)
var impulseDirection = Vector2.ZERO
var lastInputVector = Vector2.ZERO

func _ready():
	movement.setup(self)
	animationTree.active = true		

# func set_Run(): 
# 	pass

# func set_Dash_True():
# 	dashReady = true		

func _process(_delta):

	if Input.is_action_just_pressed("ui_accept"):
		combatSystem.stats.set_health(12)
	
	if playback.get_current_node() != "attack" or playback.get_current_node() != "attack2":
		if combatSystem.stats.is_dead() and playback.get_current_node() == "hurt":
			return

		if Input.is_action_just_pressed("attack") or attackPressed: 
			attackPressed = false
			if secondAttack == 0:
				playback.travel("FirstAttack")
			elif secondAttack == 1:
				playback.travel("SecondAttack")
					
func _physics_process(delta):
	input_vector = Vector2.ZERO	
	input_vector.x = Input.get_axis("move_left", "move_right")
	input_vector.y = Input.get_axis("move_up", "move_down")

	combatSystem.hitbox.knockBack_vector = attackDirection.normalized()

	if combatSystem.stats.is_dead():
		print("Dont turn cuz dead")

	if !combatSystem.stats.is_dead():
		sprite.flip(input_vector)

		if playback.get_current_node() != "attack":
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

func attack_adjusment():
	var values = $Sensor.find_closest_enemy_angle(attackDirection)
	var savedDir = attackDirection

	if values == null:
		attackDirection = savedDir
		return

	if values != null:
		var enemyDir = values["enemyDir"]
		var angle = values["angle"]

		if combatSystem.hitbox.hitted == false:
			if angle > 0 and angle < 45:
				facing = true
				attackDirection = enemyDir
				impulseDirection = enemyDir
			else:
				facing = false
				attackDirection = savedDir
				impulseDirection = savedDir

func attack_ends():
	$StateMachine.transition_to("Idle")
	attackAnimSpeed = 0.2
	attackingFromDinstance = false
	attacked = false
	facing = false
	
	if secondAttack == 0:
		secondAttack = 1
	elif secondAttack == 1:
		secondAttack= 0
	
	movement.stop_movement()

func attack_animation_finished():
	$StateMachine.transition_to("Idle")
	combatSystem.hitbox.set_hitted_state(false)
	attackAnimSpeed = 0.2
	attackingFromDinstance = false
	attacked = false
	facing = false
	
	if secondAttack == 0:
		secondAttack = 1
	elif secondAttack == 1:
		secondAttack= 0

func attackSpeed():	
	attackAnimSpeed = 0
