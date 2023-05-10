extends Area2D
class_name Sensor

@export var sensor_range: float = 5.0
@onready var shape : CollisionShape2D = $Shape

func _ready():
	shape.shape.radius = sensor_range

##Return True if a body is detecting something
func is_detecting_bodies() -> bool:
	for body in get_overlapping_bodies():
		if body != null:
			return true
	return false

func find_closest_enemy() -> CollisionObject2D:
	var nearestDistance = 500
	var closeEnemy
	var bodies = get_overlapping_bodies()

	for body in bodies:
		if body != null:
			var distance = body.global_position.distance_to(global_position)
			if distance < nearestDistance:
				nearestDistance = distance
				closeEnemy = body
	return closeEnemy

func find_closest_enemy_angle(playerDir: Vector2) -> Dictionary:
	var shortestAngle = 50
	var values = {"enemyDir": Vector2.ZERO, "angle": 0} #"enemy": CollisionObject2D#
	var bodies = get_overlapping_bodies().filter(func(body): return body.combatSystem.stats.currentHealth > 0)

	if bodies == null:
		values.clear()
		return values

	for body in bodies:

		# if body != null and body.combatSystem.stats.currentHealth > 0:
		var bodyDir =  body.global_position - global_position
		var dot = bodyDir.dot(playerDir)
		var angle = rad_to_deg(acos(dot / (playerDir.length() * bodyDir.length())))
		
		if angle < shortestAngle:
			shortestAngle = angle
			values["enemyDir"] = bodyDir
			values["angle"] = shortestAngle
			values["enemy"] = body
			values["name"] = body.name			

	return values
