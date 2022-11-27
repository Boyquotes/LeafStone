extends Area2D

var stats
var knockBack_vector

	
func disable_monitoring_and_monitorable():
    set_deferred("monitoring", false)
    set_deferred("monitorable", false)
