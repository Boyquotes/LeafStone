extends Node
class_name Stats

@export var onHealthChanged: IntGameEvent
signal HealthChanged(amount)
signal Damaged(amount)
signal Healed(amount)
signal Dead()

@export var maxHealth = 10
var currentHealth: int

var is_invincible = false
var combatSystem : CombatSystem

var behaviour_states
enum {idle, run, attack, stunned, dash, dead} #Esto debe cambiarse.

@export var damage = 2
@onready var something_hitted = false

func _ready():
	currentHealth = maxHealth

	if onHealthChanged != null:
		onHealthChanged.value = maxHealth

func setup(combat: CombatSystem):
	self.combatSystem = combat	

func set_health(value):

	#Invincibilidad, sin embargo vamos a cambiarlo con un metodo damaged
	#Dejarlo de esta forma ocacionaria problemas con habilidades de healing
	if is_invincible:
		return

	if is_dead():
		combatSystem.hurtbox.set_monitoring_and_monitorable(false)
		return 

	var previousHealth = currentHealth
	currentHealth += value
	currentHealth = clamp( currentHealth, 0, maxHealth)

	if is_dead():
		emit_signal("Dead")
		pass

	if currentHealth != previousHealth:
		emit_signal("HealthChanged", currentHealth)

		if onHealthChanged != null:
			onHealthChanged.raise_event(currentHealth)

	if currentHealth > previousHealth:
		# emit_signal("Healed", value)
		pass
	else:
		# emit_signal("Damaged", value)
		pass
		
func set_invincible(seconds):
	is_invincible = true
	combatSystem.hurtbox.set_monitoring_and_monitorable(false)
	await get_tree().create_timer(seconds).timeout
	combatSystem.hurtbox.set_monitoring_and_monitorable(true)
	is_invincible = false
	

func is_dead():
	return currentHealth <= 0
