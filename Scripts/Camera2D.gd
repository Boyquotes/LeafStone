extends Camera2D

@export var onHitboxEvent: GameEvent
@export var zoomOut :=  1.3
@export var zoomNormal := 1.0
@export var secondsToEase = 1.0

func _ready():
	onHitboxEvent.connect("OnEventHappen", Callable(self, "camera_shake"))
	setZoom(zoomNormal)

func camera_zoom(zoomVector, seconds):
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "zoom", zoomVector, seconds).set_ease(Tween.EASE_IN_OUT)

func shake():
	var tween = create_tween().set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "offset", Vector2(1, -3), 0.03).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "offset", Vector2(-3, 1), 0.03).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "offset", Vector2(0, 0), 0.03).set_ease(Tween.EASE_OUT)

func _on_Events_combatStart():
	var zoom_value = zoomScaleToVector(zoomOut)
	camera_zoom(zoom_value, secondsToEase)

func _on_Events_outOfCombat():
	var zoom__value = zoomScaleToVector(zoomNormal)
	camera_zoom(zoom__value, secondsToEase)

func camera_shake():
	shake()

func setZoom(zoom_scale):
	zoom = zoomScaleToVector(zoom_scale)

func zoomScaleToVector(zoom_scale) -> Vector2:
	return Vector2(zoom_scale, zoom_scale)
