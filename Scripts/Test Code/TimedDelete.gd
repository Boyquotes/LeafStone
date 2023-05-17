extends CPUParticles2D

@export var Hola: bool

func queue_deletion():
	$CPUParticles2D.emitting = true
	await get_tree().create_timer(lifetime).timeout
	self.queue_free()
