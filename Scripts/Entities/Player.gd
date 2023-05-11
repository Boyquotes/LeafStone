class_name Player
extends Entity

#Attack adjustment.
@export var attack_redirect = false
@export var indicator : PackedScene

var uiIndicator 
var facing = false
var attacked = false #Controls the attack adjusment happen just once.
var secondAttack = 0

@export var cooldown: float = 2.0
@export var max_speed = 38
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
	combatSystem.stats.Dead.connect(func(): stateMachine.transition_to("Dead"))

	uiIndicator = indicator.instantiate() as Node2D
	self.add_child(uiIndicator)
	uiIndicator.global_position = global_position
	uiIndicator.visible = false

func _process(_delta):

	if combatSystem.stats.is_dead():
		return

	scanForEnemies()

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

	if combatSystem.stats.is_dead():
		return

	input_vector = Vector2.ZERO	
	input_vector.x = Input.get_axis("move_left", "move_right")
	input_vector.y = Input.get_axis("move_up", "move_down")

	combatSystem.hitbox.knockBack_vector = attackDirection.normalized()
	move_and_slide()

func scanForEnemies():
	sensor.find_closest_enemy()

	if sensor.target != null:
		indicatorUpdate(sensor.target)
	else:
		uiIndicator.visible = false	

func indicatorUpdate(entity : CollisionObject2D):

	uiIndicator.global_position = entity.global_position + Vector2(0 , -30)
	uiIndicator.visible = true

func attack_adjusment():
	var closestEnemies = $Sensor.find_closest_enemy_angle(attackDirection)
	var savedDir = attackDirection

	if closestEnemies == null:
		facing = false
		attackDirection = savedDir
		return

	var enemyDir = closestEnemies["enemyDir"]
	var angle = closestEnemies["angle"]

	if angle > 0 and angle < 45:
		facing = true
		attackDirection = enemyDir
		impulseDirection = enemyDir
	else:
		facing = false

func attack_animation_finished():
	$StateMachine.transition_to("Idle")
	combatSystem.hitbox.set_hitted_state(false)
	attackAnimSpeed = 0.2
	# attacked = false
	
	if secondAttack == 0:
		secondAttack = 1
	elif secondAttack == 1:
		secondAttack= 0

func attackSpeed():	
	attackAnimSpeed = 0
