extends Node2D
class_name Movement

@export var acceleration = 1000
@export var friction = 1000
var tick = 0
var body: CharacterBody2D

func setup(_body: CharacterBody2D):
	body = _body

func _physics_process(delta):
	tick = delta

func move(input_vector: Vector2):
	# move_easing(input_vector, body.max_speed)

	body.velocity = body.velocity.move_toward(input_vector * body.max_speed, acceleration * tick)
	body.move_and_slide()
	
	if input_vector.length() > 0:
		body.velocity = body.velocity.move_toward(Vector2.ZERO, friction * tick)

# func move_easing(desired_velocity, speed):
# 	# var movementTweener = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
# 	# movementTweener.tween_property(body, "velocity", desired_velocity * speed, tick)
# 	body.set_velocity(body.velocity)
# 	body.move_and_slide()

#Movement code for 2D TOpdown view



func stop_movement():
	body.velocity = Vector2.ZERO

func impulse(desired_velocity, multiplier = 1):
	body.velocity = desired_velocity * multiplier
	body.set_velocity(body.velocity)
	body.move_and_slide()

func is_moving() -> bool:
	return body.input_vector != Vector2.ZERO

