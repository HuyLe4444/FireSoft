extends Node2D

var bodies_on_fire = []

func _ready():
	$Timer.start()
	$DamageTime.start()
	
func _on_timer_timeout():
	queue_free()

func _on_area_2d_body_entered(body):
	if body.name != "Player" and body.has_method("take_damage"):
		bodies_on_fire.append(body)
		body.take_damage()

func _on_damage_time_timeout():
	for body in bodies_on_fire:
		if is_instance_valid(body) and body.has_method("take_damage"):
			body.take_damage()

func _on_area_2d_body_exited(body):
	if body in bodies_on_fire:
		bodies_on_fire.erase(body)
		
