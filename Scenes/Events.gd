extends Node

signal combatStart
signal outOfCombat

@export var outOfCombatSeconds = 2

var detected = false
enum camera_State {normal, combat, waiting ,dialog, dramatic}
var state = camera_State.normal
var actorDetected = false
var actors = []

func _process(delta):

	if actorDetected:
		detected = true
		state = camera_State.combat

	match state:

		camera_State.normal:
			
			if !detected:
				detected = true
				emit_signal("outOfCombat")# camera_zoom(zoomNormal, secondsToEase)
		
		camera_State.combat:
			if detected:
				detected = false
				emit_signal("combatStart") #camera_zoom(zoomOut, secondsToEase)

		camera_State.waiting:
			if $ExtendedTimer.is_stopped():
				state = camera_State.normal

func _on_Sensor_body_entered(body:Node):
	actors.append(body)
	actorDetected = true

func _on_Sensor_body_exited(body:Node):

	actors.erase(body)
	if actors.size() == 0:
		actorDetected = false
		state = camera_State.waiting
		detected = false
		$ExtendedTimer.start(outOfCombatSeconds)
