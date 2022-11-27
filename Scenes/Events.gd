extends Node

signal combatStart
signal outOfCombat

var detected = false
enum camera_State {normal, combat, waiting ,dialog, dramatic}
var state = camera_State.normal
var actorDetected = false
var actors = []

export var outOfCombatSeconds = 2
# var sensorpackedScene = preload("res://Scenes/Sensor.tscn")
# onready var sensor = sensorpackedScene.instance()

func _ready():
	# add_child(sensor)
	pass

func refMethod():
	state = camera_State.normal

func _process(delta):

	if actorDetected:
		detected = true
		state = camera_State.combat

	print($ExtendedTimer.time_left)

	match state:

		camera_State.normal:
			print("normal")
			
			if !detected:
				detected = true
				emit_signal("outOfCombat")# camera_zoom(zoomNormal, secondsToEase)
		
		camera_State.combat:
			print("combat")
			if detected:
				detected = false
				emit_signal("combatStart") #camera_zoom(zoomOut, secondsToEase)

		camera_State.waiting:
			print("waiting")
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
		
