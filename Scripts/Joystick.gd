extends Area2D


onready var big_circle = $BigCircle
onready var small_circle = $BigCircle/InsideCircle

onready var max_distance = $CollisionShape2D.shape.radius

var touched = false

func _input(event):
	if event is InputEventScreenTouch:
		var distance = event.position.distance_to(big_circle.global_position)
		if !touched:
			if distance < max_distance:
				touched = true
		else:
			small_circle.position = Vector2(0,0)
			touched = false

func _process(delta):
	if touched:
		small_circle.global_position = get_global_mouse_position()
		small_circle.position = big_circle.position + (small_circle.position -
			big_circle.position).clamped(max_distance)

func joystick_axis() -> Vector2:
	var vect = Vector2(0,0)
	vect.x = small_circle.position.x / max_distance
	vect.y = small_circle.position.y / max_distance
	return vect
