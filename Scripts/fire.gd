extends Node2D

var bodies_on_fire = []
var damage = 1

func _ready():
	$Timer.start()
	$DamageTime.start()
	
func _on_timer_timeout():
	queue_free()

func _on_area_2d_body_entered(body):
	if body.name != "Player" and body.has_method("take_damage"):
		bodies_on_fire.append(body)
		for i in range(damage):
			body.take_damage()

func _on_damage_time_timeout():
	var bodies_copy = bodies_on_fire.duplicate()
	for body in bodies_copy:
		if is_instance_valid(body) and body.has_method("take_damage"):
			body.take_damage()
	
	bodies_on_fire = bodies_on_fire.filter(func(b): return is_instance_valid(b))

func _on_area_2d_body_exited(body):
	if body in bodies_on_fire:
		bodies_on_fire.erase(body)
		
