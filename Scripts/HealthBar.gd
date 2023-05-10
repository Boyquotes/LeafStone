extends Control
var tween
@onready var healthBar = $MarginContainer/HealthBar
@onready var healthLabel = $MarginContainer/HealthBar/HealthLabel
@export var onPlayerHealthChanged: IntGameEvent

@export var healthy_color: Color = Color.GREEN
@export var caution_color: Color = Color.ORANGE
@export var danger_color: Color = Color.RED

@export_range(0 , 1, 0.05) var caution_zone = 0.6
@export_range(0 , 1, 0.05) var danger_zone = 0.3

func _ready():
	onPlayerHealthChanged.OnEventRaised.connect(onHealthChange)
	healthBar.max_value = onPlayerHealthChanged.value
	healthBar.value = healthBar.max_value
	healthLabel.text = str(healthBar.value)

func onHealthChange(health):

	healthBar.value = health
	healthBarColorZones(health)
	healthLabel.text = str(health)
	$AnimationPlayer.play("Health Change")


func healthBarColorZones(health):

	if health < healthBar.max_value * danger_zone:
		healthBar.tint_progress = danger_color
	elif health < healthBar.max_value * caution_zone:
		healthBar.tint_progress = caution_color

