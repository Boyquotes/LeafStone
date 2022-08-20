extends YSort


func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		var tree = get_tree()
		var scene_cond = !tree.debug_collisions_hint
		tree.debug_collisions_hint = scene_cond
		tree.reload_current_scene()
