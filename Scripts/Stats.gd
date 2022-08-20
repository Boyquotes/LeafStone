extends Node

signal OnHealthChange(health)
signal Damaged(amount)
signal Healed(amount)
signal Dead()

export var maxHealth = 100
export(int) var currentHealth = maxHealth setget set_health

var behaviour_states
enum {idle, run, attack, stunned, dash, dead} #Esto debe cambiarse.

export var damage = 2
onready var something_hitted = false

func _ready():
    pass

func set_health(health):
    var previousHealth = currentHealth
    currentHealth += health
    currentHealth = clamp( currentHealth, 0, maxHealth)

    if is_dead():
        emit_signal("Dead")

    if currentHealth != previousHealth:
        emit_signal("OnHealthChange", currentHealth)

    if currentHealth > previousHealth:
        emit_signal("Healed", health)
    else:
        emit_signal("Damaged", health)
        

func is_dead():
    return currentHealth <= 0
