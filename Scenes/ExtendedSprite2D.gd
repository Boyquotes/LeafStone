extends Sprite2D
class_name ExtendedSprite2D

@export var onHitEvent : VoidGameEvent

func flip(direction: Vector2):

	if direction.x > 0: 
		flip_h = false
	elif direction.x < 0:
		flip_h = true

func _ready() -> void:
	if onHitEvent != null:
		onHitEvent.OnEventHappen.connect(func(): squatch())

func squatch():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.7, 1.3), 0.04).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.08).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

func stretch():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.4, 0.8), 0.03).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.08).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
