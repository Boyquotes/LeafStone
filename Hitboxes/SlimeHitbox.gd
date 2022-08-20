extends Area2D

var slimeStats
var hitted = false

# func _on_SlimeHitbox_body_entered(body:Node):
# 	hitted = true
# 	print(body.playerStats.currentHealth)
# 	body.playerStats.currentHealth -= stats.damage
# 	print(body.playerStats.currentHealth)



func _on_SlimeHitbox_area_entered(area:Area2D):
	hitted = true
	area.stats.set_health(-slimeStats.damage)
	print(area.stats.currentHealth)
