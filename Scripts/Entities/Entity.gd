class_name Entity
extends CharacterBody2D

@onready var movement : Movement = $Movement
@onready var combatSystem = $CombatSystem
@onready var bodyshape = $BodyShape
@onready var sprite = $Sprite2D
@onready var sensor = $Sensor

#Animation Variables
@onready var animationTree = $AnimationTree
@onready var animationPlayer = $AnimationPlayer
@onready var playback = animationTree.get("parameters/playback")
