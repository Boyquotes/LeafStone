extends Control
var tween
@onready var healthBarUnder = $HealthBarUnder
@onready var healthBar = $HealthBar
@onready var healthLabel = $HealthLabel

@export var healthy_color: Color = Color.GREEN
@export var caution_color: Color = Color.ORANGE
@export var danger_color: Color = Color.RED

@export_range(0 , 1, 0.05) var caution_zone = 0.6
@export_range(0 , 1, 0.05) var danger_zone = 0.3

func _ready():
	pass

func _on_Stats_OnHealthChange(health:int):
	healthBar.value = health
	healthBarColorZones(health)
	healthLabel.text = str(health)
	tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.interpolate_property(healthBarUnder, "value", healthBarUnder.value, health, 0.4, tween.TRANS_SINE, tween.EASE_IN_OUT, 0.4)
	$AnimationPlayer.play("Health Change")


func healthBarColorZones(health):

	if health < healthBar.max_value * danger_zone:
		healthBar.tint_progress = danger_color
	elif health < healthBar.max_value * caution_zone:
		healthBar.tint_progress = caution_color

