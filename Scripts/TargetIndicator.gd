extends Node2D

var indicatorScale : float = 1.0
var entity: Entity 
var oldTarget : CollisionObject2D
@onready var sprite : Sprite2D = $Sprite

func _ready():
	visible = false
	entity = get_tree().get_first_node_in_group("Player")
	animation()

func animation():
	var tween = create_tween().set_trans(Tween.TRANS_QUAD)
	tween.tween_property(sprite, "offset", Vector2(0,5), 0.7)
	tween.tween_property(sprite, "offset", Vector2.ZERO, 0.7)
	tween.set_loops(-1)
	# var tween = create_tween().set_trans(Tween.TRANS_QUAD)
	# tween.tween_property(self, "scale", Vector2(1.3,1.3), 1)
	# tween.tween_property(self, "scale", Vector2(0.8,0.8), 1)
	# tween.set_loops(-1)

func scaleAnimation():
	scale = Vector2(0.1, 0.1)
	var tween = create_tween().set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.25).set_ease(Tween.EASE_IN)

func _process(delta):
	indicator_update()

func indicator_update():

	if entity.sensor.target:
		
		global_position = entity.sensor.target.global_position + Vector2(0 , -30)

		if oldTarget != entity.sensor.target:
			oldTarget = entity.sensor.target
			scaleAnimation()

		visible = true
	else:
		visible = false

