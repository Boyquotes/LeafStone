extends Control
var game_pause_state = false :
	get:
		return game_pause_state # TODOConverter40 Non existent get function 

func _unhandled_input(event):
	pass
	if event.is_action_pressed("ui_cancel"):
		self.game_pause_state = !game_pause_state

func set_pause(value):
	game_pause_state = value
	get_tree().paused = game_pause_state
	visible = game_pause_state

func _on_ReestartBtn_pressed():
	self.game_pause_state = false
	debug_collisions()

func debug_collisions():
	var tree = get_tree()
	var collisions_hint_state = !tree.debug_collisions_hint
	tree.debug_collisions_hint = collisions_hint_state
	tree.reload_current_scene()

func _on_QuitBtn_pressed():
	get_tree().quit()


func _on_ResumeBtn_pressed():
	self.game_pause_state = false

