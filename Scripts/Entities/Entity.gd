class_name Entity
extends CharacterBody2D

@onready var movement : Movement = $Movement
@onready var combatSystem :CombatSystem = $CombatSystem
@onready var bodyshape = $BodyShape
@onready var sprite = $Sprite2D
@onready var sensor : Sensor = $Sensor
@onready var stateMachine : StateMachine = $StateMachine

#Animation Variables
@onready var animationTree = $AnimationTree
@onready var animationPlayer = $AnimationPlayer
@onready var playback = animationTree.get("parameters/playback")
