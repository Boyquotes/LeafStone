extends Node
class_name Stats

signal OnHealthChange(value)
signal Damaged(amount)
signal Healed(amount)
signal Dead()

@export var maxHealth = 100
@export var currentHealth: int = maxHealth

var invincible = false

var behaviour_states
enum {idle, run, attack, stunned, dash, dead} #Esto debe cambiarse.

@export var damage = 2
@onready var something_hitted = false

func _ready():
	pass

func set_health(value):

	#Invincibilidad, sin embargo vamos a cambiarlo con un metodo damaged
	#Dejarlo de esta forma ocacionaria problemas con habilidades de healing
	if invincible:
		return

	var previousHealth = currentHealth
	currentHealth += value
	currentHealth = clamp( currentHealth, 0, maxHealth)

	if is_dead():
		emit_signal("Dead")

	if currentHealth != previousHealth:
		emit_signal("OnHealthChange", currentHealth)

	if currentHealth > previousHealth:
		emit_signal("Healed", value)
	else:
		emit_signal("Damaged", value)
		
func set_invincible(value, seconds):
	invincible = value
	await get_tree().create_timer(seconds).timeout
	invincible = false
	

func is_dead():
	return currentHealth <= 0
