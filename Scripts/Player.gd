extends KinematicBody2D

export(float) var cooldown = 2
export var adjust_attack : bool =  true
var velocity = Vector2.ZERO
export var max_speed = 35
export var attackImpulse = 100
export (AudioStream) var runSound
export (AudioStream) var attackSound

var dashReady = true


enum {idle, run, attack, stunned, dash, dead, hurt}
var behaviour_states = idle
var moveFromAttack = false
var allowToAttack = true

export var attackAnticipation = false
var att_once = false
var dist = 0.0
var attackAnimSpeed = 0.2
var attackFromDistance = false

#Animation Variables
onready var animationTree = $AnimationTree
onready var playback = animationTree.get("parameters/playback")
var adjusted = false

onready var playerStats = $Stats
onready var hurtbox = $HurtBox
onready var hitbox = $Hitbox

onready var movement = $Movement
var attackDirection = Vector2.ZERO
var impulseDirection = Vector2.ZERO

func _ready():

	movement.setMovement(self)

	behaviour_states = idle
	hitbox.playerStats = playerStats
	hurtbox.stats = playerStats
	animationTree.active = true
	attackDirection = Vector2(1,1)
	$RunningSource.playing = true
	$Hitbox/Shape.set_deferred("disabled", true)
	
func _process(_delta):

	playerStats.behaviour_states = behaviour_states

	if Input.is_action_just_pressed("ui_accept"):
		playerStats.set_health(12)

	if Input.is_action_just_pressed("Dash") and dashReady:
		behaviour_states = dash
		# $Sprite.modulate = Color()
		yield(get_tree().create_timer(0.18), "timeout")
		behaviour_states = run
		yield(get_tree().create_timer(cooldown), "timeout")
		dashReady = true
		# $Sprite.modulate = Color("#ffffff")
		
	
	if playback.get_current_node() != "Attack":
		if Input.is_action_just_pressed("attack") and allowToAttack:
			if !playerStats.is_dead():
				behaviour_states = attack

func _physics_process(delta):
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	velocity = input_vector.normalized()

	hitbox.knockBack_vector = attackDirection.normalized()

	if playerStats.is_dead():
		behaviour_states = dead

	match behaviour_states:

		idle:
			adjusted = false
			$RunningSource.stop()
			playback.travel("Idle")
			movement.move(Vector2.ZERO)

			if velocity != Vector2.ZERO:
				behaviour_states = run
		run:
			att_once = false
			if !$RunningSource.playing:
				$RunningSource.stream = runSound
				$RunningSource.play()


			playback.travel("Run")
			if input_vector != Vector2.ZERO:
				attackDirection = input_vector.normalized()
				impulseDirection = input_vector.normalized()

			if moveFromAttack: #move slow
				movement.time_move(input_vector,  0.05, "slow", "normal_speed")
			elif !moveFromAttack: #move normal
				movement.move(input_vector * max_speed)

			if velocity == Vector2.ZERO:
				behaviour_states = idle

		attack:
			allowToAttack = false
			moveFromAttack = true
			star_Timer(0.08)
			
			if !adjusted:
				attack_adjustment()
				adjusted = true

			if attackDirection != Vector2.ZERO:
				playback.travel("Attack")
				animationTree.set("parameters/Attack/blend_position", attackDirection)
				_spriteRotation(attackDirection)
			
			#Esto deberia ocurrir con un evento y estar fuera de aca.
			if hitbox.berserk:
				$Sprite.modulate = Color()
			else:
				$Sprite.modulate = Color("#ffffff")
			
				# Attack Logic
			
			var closEnemy = look_closest_enemy()
			var distance = 50
			if closEnemy != null:
				distance = global_position.distance_to(closEnemy)
			

			#Modificar que la velocidad se vea afectada tambien con que tal cerca estamos
			if distance < 60:

				# if !playback.is_playing():
				if attackFromDistance:
					animationTree.advance(0)
				else:
					animationTree.advance(attackAnimSpeed)

			elif distance > 55 and distance < 110:
				attackFromDistance = true
				if attackAnticipation:
					animationTree.advance(0)
					if att_once == false:
						yield(get_tree().create_timer(0.2),"timeout")
						att_once = true 
			else:
				animationTree.advance(attackAnimSpeed)
				attackFromDistance = false
			
			if !hitbox.hitted:
				if attackFromDistance:
					movement.impulse(impulseDirection.normalized() * 220) #mantener con input_vector
				else:
					movement.impulse(impulseDirection.normalized() * 90) #mantener con input_vector
				pass
			else:
				movement.impulse(impulseDirection.normalized() * attackImpulse / 4)
			
			if $RunningSource.stream != attackSound:
				$RunningSource.stream = attackSound
				$RunningSource.play()	

		dash:
			playback.travel("Dash")
			dashReady = false
			movement.impulse(impulseDirection.normalized() * 240)
			attack_adjustment()

		hurt:
			behaviour_states = idle
			pass

		dead:
			movement.move(Vector2.ZERO)
			playback.travel("Dead")
			rotation_degrees = 90

	if !playerStats.is_dead():
		_spriteRotation(input_vector)

		if playback.get_current_node() != "Attack":
			velocity = move_and_slide(velocity)
	
func attack_adjustment():

	if adjust_attack:
		var closeEnemyPosition = look_closest_enemy()
		
		if closeEnemyPosition != null:
			dist = global_position.distance_to(closeEnemyPosition)
			
			if dist < 150:
				print("Si")
				var normalizePos = global_position.normalized()
				var normalizeEnemyPos = closeEnemyPosition.normalized()
				var dotproduct = normalizePos.dot(normalizeEnemyPos)

				var angleToEnemy = rad2deg(acos(dotproduct))
				if angleToEnemy < 80/2:
					attackDirection = (normalizeEnemyPos - normalizePos)
				

func look_closest_enemy():
	var nearestDistance = 500
	var closeEnemyPos
	var areas = $DetentionArea.get_overlapping_areas()

	for area in areas:
		if area != null:
			var distance = area.global_position.distance_to(global_position)
			if distance < nearestDistance:
				nearestDistance = distance
				closeEnemyPos = area.global_position
	return closeEnemyPos
		
func _spriteRotation(input_direction):

	if playback.get_current_node() != "Attack":
		if input_direction.x > 0: 
			$Sprite.flip_h = false #Derecha
		elif input_direction.x < 0:
			$Sprite.flip_h = true #izquierda flip

func attack_animation_finished():
	behaviour_states = run
	attackAnimSpeed = 0.2
	attackFromDistance = false

func star_Timer(sec):
	$Timer.wait_time = sec
	$Timer.start()

func _on_Timer_Completed():
	hitbox.hitted = false
	moveFromAttack = false
	allowToAttack = true
	adjusted = false

func _on_Stats_Damaged(amount):
	behaviour_states = hurt

func attackSpeed():	
	attackAnimSpeed = 0

func _on_Stats_Dead():
	$HurtBox.monitorable = false
	$HurtBox.monitoring = false
	$Hitbox.monitoring = false
	$DetentionArea.monitoring = false
	$BodyShape.set_deferred("disabled", true)
