extends Camera2D

export var zoomOut :=  1.3
export var zoomNormal := 1.0
export var secondsToEase = 1.0

const CAMERASHAKE : String = "CameraShake"

func _ready():
	setZoom(zoomNormal)
	
onready var cameraAnim = $AnimationPlayer

func camera_zoom(zoomVector, seconds):
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "zoom", zoomVector, seconds).set_ease(Tween.TRANS_LINEAR)

func _on_Events_combatStart():
	var zoom_value = zoomScaleToVector(zoomOut)
	camera_zoom(zoom_value, secondsToEase)

func _on_Events_outOfCombat():
	var zoom__value = zoomScaleToVector(zoomNormal)
	camera_zoom(zoom__value, secondsToEase)

func _on_Hitbox_body_entered(body:Node):
	cameraAnim.play("CameraShake")

func setZoom(zoom_scale):
	zoom = zoomScaleToVector(zoom_scale)

func zoomScaleToVector(zoom_scale) -> Vector2:
	return Vector2(zoom_scale, zoom_scale)