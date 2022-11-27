extends Node2D
class_name Movement

onready var transitionTimer = $TransitionTimer
onready var movementTweener = $MovementTweener

var tick = 0
var next_state
var current_state = MOVEMENT_TYPE.stopped
var choose_state
var started = false
var body: KinematicBody2D


export (String, "stopped", "normalspeed", "slow", "dash") var state
enum MOVEMENT_TYPE {stopped, normalspeed, slow, dash}
var movement_states: Dictionary  = {
	"stopped": MOVEMENT_TYPE.stopped,
	"normal_speed": MOVEMENT_TYPE.normalspeed,
	"slow": MOVEMENT_TYPE.slow,
	"dash": MOVEMENT_TYPE.dash
	}
func setMovement(_body: KinematicBody2D):
	body = _body

func _ready():
	pass

func _physics_process(delta):
	tick = delta

#The basic method to move a KinematicBody2D
func move(input_vector: Vector2):
	move_easing(input_vector, body.max_speed)

#input_vector is for the player input or the direction Vector.  seconds is the seconds to transition
#"state_type" is a string variable for the type of the movement is desired to add the movement states available are "stopped" = zero speed, "normal_speed" or "slow"
#no time definition means type of movement doest change.
func time_move(input_vector: Vector2, seconds: float, state_type:String, state_to_transition:String = "default") -> bool:
	
	#Con la variable stateType definimos el tipo de movimiento que va tener
	#durante los segundos establecidos, si no se define segundos entonces no habra
	#cambio en el estado, por lo tanto necesitamos un timer
	current_state = movement_states[state_type]
	if state_to_transition != "default":
		next_state = movement_states[state_to_transition]

	if seconds > 0:
		timed_transition(seconds)
	else:
		start_transition()

	match(current_state):
		MOVEMENT_TYPE.stopped:
			move_easing(Vector2.ZERO, 0)

		MOVEMENT_TYPE.normalspeed:
			move_easing(input_vector, body.max_speed)

		MOVEMENT_TYPE.slow:
			move_easing(input_vector, 4)

		MOVEMENT_TYPE.dash:
			body.velocity = input_vector * 9
			body.velocity  = body.move_and_slide(input_vector * 15)

	return transitionTimer.is_stopped()
		

func timed_transition(seconds):

	if started == false:
		started = true
		transitionTimer.start(seconds)
		start_transition()

func one_shot_movement(seconds):
	if started == false:
		started = true
		transitionTimer.start(seconds)

func start_transition():
	current_state = choose_state

func stop_movement():
	body.velocity = Vector2.ZERO
		
func move_easing(desired_velocity, speed):

	movementTweener.interpolate_property(body, "velocity", body.velocity, desired_velocity, tick, Tween.TRANS_LINEAR , Tween.EASE_OUT)
	movementTweener.start()
	body.velocity = body.move_and_slide(body.velocity * speed)

func impulse(desired_velocity, multiplier = 1):
	body.velocity  = body.move_and_slide(desired_velocity * multiplier)

func _on_Timer_timeout():
	current_state = next_state
	pass
