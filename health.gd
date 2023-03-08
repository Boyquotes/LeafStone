extends Node

enum State {
	NORMAL,
	DAMAGED,
	INVULNERABLE
}

var max_health : int = 100
var current_health = max_health
var current_state = State.NORMAL
var invulnerability_time : float = 2.0
var invulnerability_timer = 0
var blinking = false

func take_damage(damage : int) -> void:
	if current_state != State.INVULNERABLE:
		current_state = State.DAMAGED
		current_health -= damage
		if current_health <= 0:
			die()
		else:
			invulnerability_timer = invulnerability_time
			current_state = State.INVULNERABLE

func die() -> void:
	print("I am dead!")
	queue_free()

func heal(amount : int) -> void:
	current_health += amount
	if current_health > max_health:
		current_health = max_health

func _process(delta: float) -> void:
	invulnerability_timer -= delta
	if invulnerability_timer <= 0:
		current_state = State.NORMAL
		blinking = false
		update_visuals()
	else:
		if not blinking:
			blinking = true
			update_visuals()

func update_visuals():
	if current_state == State.DAMAGED:
		# Change sprite or animation to damaged state
		pass
	elif current_state == State.INVULNERABLE:
		# Change sprite or animation to invulnerable state
		# and add a blinking effect if blinking is true
		pass
	else:
		# Change sprite or animation to normal state
		pass

func get_health_percentage() -> float:
	return current_health / max_health

