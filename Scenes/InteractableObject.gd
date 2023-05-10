extends Node2D

var label = null
@export var traisitionType : Tween.TransitionType
@export var easeType : Tween.EaseType

func _ready():
	label = $Node2D/Label
	label.modulate = Color.TRANSPARENT

func _on_InteractButton_pressed():
	# Handle interaction with the object here
	hide_label()

func show_label():
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(label, "modulate", Color.WHITE_SMOKE, 0.2).set_ease(Tween.EASE_IN_OUT)

func hide_label():
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(label, "modulate", Color.TRANSPARENT, 0.2).set_ease(Tween.EASE_IN_OUT)

func _on_sensor_body_entered(body: Node2D) -> void:
	show_label()

func _on_sensor_body_exited(body: Node2D) -> void:
	hide_label()
