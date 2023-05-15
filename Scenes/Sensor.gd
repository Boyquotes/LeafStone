extends Area2D
class_name Sensor

@export var sensor_range: float = 5
@export var vision_angle: float = 45

@onready var shape : CollisionShape2D = $Shape
var target : CollisionObject2D

@export_category("Debug Data")
@export var vision_color: Color
@export var draw_distance: float = 160
@export var draw_vision: bool = true

func _ready():
	shape.shape.radius = sensor_range

func get_target_distance() -> float:
	return target.global_position.distance_to(global_position)
	

func Scan() -> void:
	var bodies = get_overlapping_bodies()
	var closestBody = find_closest_body(bodies)

	if closestBody != null:
		target = closestBody
	else:
		target = null

func _process(delta):
	queue_redraw()

func find_closest_body(bodies: Array) -> CollisionObject2D:
	var nearestDistance = 500
	var closestBody: CollisionObject2D = null

	if bodies.size() < 0:
		target = null

	for body in bodies:
		if body != null:
			var distance = body.global_position.distance_to(global_position)
			if distance < nearestDistance:
				nearestDistance = distance
				closestBody = body
				target = closestBody

	return closestBody

func find_close_body_on_vision(playerDir: Vector2) -> CollisionObject2D:

	var bodies = get_overlapping_bodies()
	var closestBody: CollisionObject2D = null
	var bodiesOnVision : Array[CollisionObject2D]
	
	if bodies == null:
		return

	for body in bodies:

		var angle = calculate_angle(playerDir, body)
		var onSight = angle >= 0 and angle <= vision_angle

		if onSight:
			bodiesOnVision.append(body)
	
	if bodiesOnVision == null:
		return

	# if bodiesOnVision.size() < 0:
	# 	closestBody = null

	closestBody = find_closest_body(bodiesOnVision)
	return closestBody

func calculate_angle(playerDirection: Vector2, otherBody: CollisionObject2D) -> float:
	var bodyDir = otherBody.global_position - global_position
	var dot = bodyDir.dot(playerDirection)
	return rad_to_deg(acos(dot / (playerDirection.length() * bodyDir.length())))

func _draw():
	# var playerDir = global_transform.xform(Vector2(1, 0)).normalized()
	# var playerDir = global_position.direction_to(Vector2(1, 0)).normalized()

	if get_parent().name != "Player":
		return
	
	if draw_vision == false:
		visible = false
		return

	visible = true	

	var playerNode = get_tree().get_first_node_in_group("Player") as Player
	var playerDir = playerNode.impulseDirection.normalized()
	var halfAngle = deg_to_rad(vision_angle / 2)
	var coneStart = playerDir.rotated(-halfAngle)
	var coneEnd = playerDir.rotated(halfAngle)

	var coneCenter = -playerDir
	var coneStartPos = coneCenter + coneStart * draw_distance
	var coneEndPos = coneCenter + coneEnd * draw_distance

	var startAngle = atan2(coneEnd.y, coneEnd.x)
	var endAngle = atan2(coneStart.y, coneStart.x)

	draw_line(coneStartPos, coneCenter, vision_color, 2.0)
	draw_line(coneEndPos, coneCenter, vision_color, 2.0)
	draw_arc(coneCenter, draw_distance, startAngle, endAngle, 64, vision_color, 2.0)
