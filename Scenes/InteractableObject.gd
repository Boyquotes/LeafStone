extends Node2D

@onready var label : Label = $Node2D/InteractionMessageLbl
@export var traisitionType : Tween.TransitionType
@export var easeType : Tween.EaseType
@export var anim = false

func _ready():
	label.modulate = Color.TRANSPARENT

func _on_InteractButton_pressed():
	# Handle interaction with the object here
	hide_label()

func show_label():
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(label, "modulate", Color.WHITE_SMOKE, 0.2).set_ease(Tween.EASE_IN_OUT)

func lable_animation():
	#Vector2(-58,24)

	if anim == false:
		return
		
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(label, "position", Vector2(-28,-22), .6)
	tween.tween_property(label, "position", Vector2(-28,-16), .6)
	tween.set_loops(-1)


func hide_label():
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(label, "modulate", Color.TRANSPARENT, 0.2).set_ease(Tween.EASE_IN_OUT)

func _on_sensor_body_entered(body: Node2D) -> void:
	show_label()
	lable_animation()

func _on_sensor_body_exited(body: Node2D) -> void:
	hide_label()
