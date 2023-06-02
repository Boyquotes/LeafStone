extends PlayerState


func enter(_msg := {}) -> void:
	entity.playback.travel("Dead")

func perform_update(delta):
	print("cant Move because you are dead")

func perform_physics_update(delta):
	entity.movement.stop_movement()
	
func exit():
	pass


