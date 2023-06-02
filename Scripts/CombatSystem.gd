@tool
extends Node2D
class_name CombatSystem

enum ActorType { undefined, player, enemy}
@onready var stats : Stats = $Stats
@onready var hitbox: Hitbox = $HitBox
@onready var hurtbox : Hurtbox = $HurtBox
@onready var slowMotion: SlowMotion = $SlowMotion

@export_subgroup("Events")
@export var onHitEvent : VoidGameEvent
@export var onHurtBox : VoidGameEvent

@export_group("Hitbox Data")
@export var actor_Type: ActorType
@export var hitboxRadius = 16.0
@export var hitbox_state : bool 
@export var hitbox_position = Vector2()
@export var impact_particles : PackedScene = preload("res://Resources/Particles/ImpactParticles.tscn")
@export var floating_damage : PackedScene

@export_group("Sound Effects Resources")
@export var attackSFX : AudioStream
@export var hurtSFX : AudioStream

func _ready() -> void:
	
	if Engine.is_editor_hint() == false:
		hitbox.shape.shape.radius = hitboxRadius
		hurtbox.setup(stats)
		hitbox.setup(stats)
		stats.setup(self)

	match actor_Type:

		ActorType.player:
			hurtbox.collision_layer = 2 #Player
			hitbox.collision_mask = 4 #Enemy tambien golpea a 6

		ActorType.enemy:
			hurtbox.collision_layer = 4 #Enemy
			hitbox.collision_mask = 2 #Player

		ActorType.undefined: #trampa
			hurtbox.collision_layer = 0 # 6 | Trampa
			hitbox.collision_mask = 0 # 2 | Player
		
		
func _physics_process(delta: float) -> void:
	hitbox.position = hitbox_position
	set_hitbox_active_state(hitbox_state)

func set_hitbox_active_state(value : bool):
	hitbox_state = value
	if Engine.is_editor_hint() == false:
		hitbox.active(hitbox_state)

func _on_hitbox_area_entered(hurtbox:Area2D) -> void:

	if stats.is_invincible:
		return

	hurtbox.take_damage(stats.damage, hurtSFX,
		-hitbox.knockBack_vector.normalized())

	if floating_damage != null:
		var textNode = floating_damage.instantiate()
		hurtbox.add_sibling(textNode)
		textNode.set_text(stats.damage)
		textNode.global_position = hurtbox.global_position + Vector2(0 , -5)	

	if impact_particles != null:
		var particles = impact_particles.instantiate()
		add_sibling(particles)
		particles.global_position = hurtbox.global_position
		particles.emitting = true
		particles.direction = hitbox.knockBack_vector * 8
		particles.queue_deletion()


	hitbox.play(attackSFX)
	hitbox.set_hitted_state(true)

	if onHitEvent != null:
		onHitEvent.raise_event()

func _on_hurt_box_area_entered(area:Area2D) -> void:
	onHurtBox.raise_event()
