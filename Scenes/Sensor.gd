extends Area2D
class_name Sensor

@export var sensor_range: float = 5.0
@onready var shape : CollisionShape2D = $Shape
var target : CollisionObject2D

func _ready():
	shape.shape.radius = sensor_range

func find_closest_enemy() -> CollisionObject2D:
	var bodies = get_overlapping_bodies()
	var closestBody = find_closest_body(bodies)

	if closestBody != null:
		target = closestBody
	else:
		target = null

	return closestBody

func find_closest_enemy_vision_cone(playerDir: Vector2) -> CollisionObject2D:
	var bodies = get_overlapping_bodies()
	var closestBody = find_closest_body(bodies)

	return closestBody

func find_closest_body(bodies: Array) -> CollisionObject2D:
	var nearestDistance = 500
	var closestBody: CollisionObject2D = null

	for body in bodies:
		if body != null:
			var distance = body.global_position.distance_to(global_position)
			if distance < nearestDistance:
				nearestDistance = distance
				closestBody = body

	return closestBody

func calculate_angle(playerDirection: Vector2, otherBody: CollisionObject2D) -> float:
	var bodyDir = otherBody.global_position - global_position
	var dot = bodyDir.dot(playerDirection)
	return rad_to_deg(acos(dot / (playerDirection.length() * bodyDir.length())))
