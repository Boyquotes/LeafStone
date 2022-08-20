extends Sprite

var d =0.0
onready var parent = get_parent()

func _process(delta):
	
	var posOffset = parent.position - position

	position = posOffset + parent.velocity.normalized() 
	
# 	d +=  delta

# 	position = Vector2(sin(d * 2) * 150.0,
# cos(d * 2) * 150.0) + parent.global_position

	
