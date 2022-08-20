extends Control


func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		var condition = $VBoxContainer.visible
		$VBoxContainer.visible = !condition

func _on_Button_button_down():
	get_tree().reload_current_scene()
