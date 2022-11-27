extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	$PlayerGUI/TouchControls.visible = false
	if OS.has_touchscreen_ui_hint():
		$PlayerGUI/TouchControls.visible = true
