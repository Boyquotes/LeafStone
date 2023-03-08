#dash.gd
extends PlayerState

@export var cooldown = 4

func enter(_msg := {}) -> void:

	Engine.time_scale = 1
	player.animationTreePlayback.travel("Dash")

	var dashLenght = player.animationTreePlayback.get_current_length()
	player.combatSystem.stats.set_invincible(true, dashLenght)
	player.animationPlayer.connect("animation_finished", func(): state_machine.transition_to("Run"))
	player.animationPlayer.connect("animation_finished", func(): coolDown())

func coolDown() -> void:
	player.dashReady = false

	player.extended2.performTimer(cooldown, func(): player.dashReady = true)
	$Timer.start(cooldown).connect("timeout", player, "dashReady", [true])

func perform_physics_update(delta: float) -> void:

	player.movement.impulse(player.impulseDirection.normalized() * 140)

	if Input.is_action_just_pressed("attack") or player.attackPressed: 
		player.attackPressed = false
		player.animationTreePlayback.stop()
		player.attackAnimSpeed = 0.2
