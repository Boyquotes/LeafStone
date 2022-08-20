extends Area2D

func is_colliding():
	var areas = get_overlapping_areas()
	return areas.size() > 0

func push_vector():
	var areas = get_overlapping_areas()
	var push_vect = Vector2.ZERO

	if is_colliding():
		var area = areas[0]
		push_vect = area.global_position.direction_to(global_position)
		push_vect = push_vect.normalized()
		
	return push_vect
