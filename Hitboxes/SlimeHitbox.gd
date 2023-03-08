extends Area2D

var slimeStats
var hitted = false

# This function disables both monitoring and monitorable. 
# It does this by setting the deferred values of both "monitoring" and "monitorable" to false.
func disable_monitoring_and_monitorable():
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)

#Signals.
func _on_slime_hitbox_hit(area:Area2D) -> void:
	hitted = true
	area.stats.set_health(-slimeStats.damage)
