extends Label


func _process(delta: float) -> void:
	text = "Fps: " + str(Engine.get_frames_per_second())
