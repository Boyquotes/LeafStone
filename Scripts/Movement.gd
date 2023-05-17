extends Node2D
class_name Movement

@export var seconds = 0.15
@export var secondsMaxSpeed = 0.3
@export var max_speed = 52
@export var slow_speed = 32
@export var friction = 300
var body: CharacterBody2D
var accelerated = false
var tick = 0.0

func setup(_body: CharacterBody2D):
	body = _body
	accelerated = false

func _physics_process(delta: float) -> void:
	tick = delta

func move(input_vector: Vector2):

	if accelerated == false:
		accelerated = true
		body.speed = 24
		var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(body, "speed", slow_speed, seconds).set_ease(Tween.EASE_IN)
		tween.tween_property(body, "speed", max_speed, secondsMaxSpeed).set_ease(Tween.EASE_OUT)
		
	body.velocity = body.speed * input_vector
	body.move_and_slide()

func stop_movement():
	body.velocity = body.velocity.move_toward(Vector2.ZERO, friction * tick)
	body.move_and_slide()
	accelerated = false

func impulse(direction, scaler = 1):
	body.velocity = direction * scaler
	body.move_and_slide()

func is_moving() -> bool:
	return body.input_vector != Vector2.ZERO

