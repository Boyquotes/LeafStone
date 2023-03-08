@tool
extends Node2D

enum ActorType { undefined, player, enemy}
@onready var stats : Stats= $Stats
@onready var hitbox: Hitbox = $HitBox
@onready var hurtbox = $HurtBox

@export var hitboxRadius = 16.0
@export var onHitEvent : GameEvent
@export var onHurtBox : GameEvent
@export var hitbox_state : bool 
@export var hitbox_position = Vector2()
@export var actor_Type: ActorType
@export var attackSFX : AudioStream
@export var hurtSFX : AudioStream

func _ready() -> void:

	if Engine.is_editor_hint() == false:
		hurtbox.setup(stats)
		hitbox.setup(stats)
		hitbox.shape.shape.radius = hitboxRadius

	match actor_Type:

		ActorType.player:
			hurtbox.collision_layer = 2
			hitbox.collision_mask = 4

		ActorType.enemy:
			hurtbox.collision_layer = 4
			hitbox.collision_mask = 2

		ActorType.undefined:
			hurtbox.collision_layer = 0
			hitbox.collision_mask = 0
		
func _physics_process(delta: float) -> void:
	hitbox.position = hitbox_position
	set_hitbox_active_state(hitbox_state)

func set_hitbox_active_state(value : bool):
	hitbox_state = value
	if Engine.is_editor_hint() == false:
		hitbox.active(hitbox_state)

func _on_hitbox_area_entered(area:Area2D) -> void:
	area.take_damage(area, hitbox.stats.damage, hurtSFX,
		-hitbox.knockBack_vector.normalized())
	hitbox.play(attackSFX)

	if onHitEvent != null:
		onHitEvent.raise_event()
