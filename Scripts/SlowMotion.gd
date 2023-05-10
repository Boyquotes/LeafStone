extends Node
class_name SlowMotion

@export var time_scale = 0.35
@export var duration = 0.2

#The standard freeze is 'time_scale' = 0.45 and 'duration' = 0.25
func start_slow_motion():
	Engine.time_scale = time_scale
	await get_tree().create_timer(duration * time_scale).timeout
	Engine.time_scale = 1

