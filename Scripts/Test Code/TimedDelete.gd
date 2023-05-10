extends CPUParticles2D

func queue_deletion():
	$CPUParticles2D.emitting = true
	await get_tree().create_timer(lifetime).timeout
	self.queue_free()
