extends AttackBehavior
class_name MeleeAttackBehavior

@export var attack_range = 50.0
@export var attack_damage = 10.0

func perform_attack(enemy: Enemy):
    var distance_to_target = enemy.global_position.distance_to(enemy.target.global_position)
    
    if distance_to_target <= attack_range:
        # Apply melee attack damage to the target
        enemy.target.apply_damage(attack_damage)
