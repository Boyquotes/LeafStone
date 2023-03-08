extends Node

@export var time_scale = 0.45
@export var duration = 0.25

#The standard freeze is 'time_scale' = 0.45 and 'duration' = 0.25
func start_slow_motion():
	Engine.time_scale = time_scale
	await get_tree().create_timer(duration * time_scale).timeout
	Engine.time_scale = 1

# func _process(delta):
	# set_process(false) #stop processing to start slowmotion
	# start_slow_motion()
	# set_process(true) #resume processing

