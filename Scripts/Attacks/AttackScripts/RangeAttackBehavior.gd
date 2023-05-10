class_name RangeAttackBehavior
extends AttackBehavior 

@export var projectile_scene : PackedScene
@export var attack_range = 150.0
@export var fire_rate = 1.0
@export var projectile_speed = 200.0

var time_since_last_shot = 0.0

func perform_attack(enemy: Enemy):
    # time_since_last_shot += delta
    #Aca utilizamos un Timer.
    if time_since_last_shot >= 1.0 / fire_rate:
        var distance_to_target = enemy.global_position.distance_to(enemy.target.global_position)
        
        if distance_to_target <= attack_range:
            # Spawn a projectile and set its direction and speed
            var projectile = projectile_scene.instance()
            enemy.get_parent().add_child(projectile)
            projectile.global_position = enemy.global_position
            projectile.direction = (enemy.target.global_position - enemy.global_position).normalized()
            projectile.speed = projectile_speed
            
            # Reset the timer
            time_since_last_shot = 0.0
