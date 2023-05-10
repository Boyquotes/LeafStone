extends Node2D

@export var stats : Stats
var healthBar : TextureProgressBar

func _ready():
	healthBar = $HealthBar
	stats.HealthChanged.connect(updatehealth)
	healthBar.max_value = stats.maxHealth

func updatehealth(amount):

	healthBar.value = amount
	if healthBar.value <= 0:
		healthBar.visible = false
