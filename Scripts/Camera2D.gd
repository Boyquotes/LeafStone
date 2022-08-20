extends Camera2D

var detected = false
const CAMERASHAKE : String = "CameraShake"

onready var cameraAnim = $AnimationPlayer
func _ready():
	pass

func _on_Hitbox_area_entered(area:Area2D):
	cameraAnim.play("CameraShake")

func _on_DetentionArea_body_entered(body:Node):

	if !detected:
		detected = true
		cameraAnim.play("EnemyDetected")
