extends Area2D

var slimeStats
var hitted = false

func _on_SlimeHitbox_area_entered(area:Area2D):
	hitted = true
	area.stats.set_health(-slimeStats.damage)
	print(area.stats.currentHealth)

func disable_monitoring_and_monitorable():
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)