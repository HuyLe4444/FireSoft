extends Node2D

var fire = preload("res://Scenes/fire.tscn")
var damage_radius = 200

func _ready():
	$CPUParticles2D.emitting = true
	$CPUParticles2D.one_shot = true
	
	deal_damage()
	fire_carpet()
	
	$Timer.start()

func deal_damage():
	await get_tree().physics_frame
	for body in $Area2D.get_overlapping_bodies():
		if body.has_method("take_damage"):
			body.take_damage()
			body.take_damage()
			body.take_damage()

func fire_carpet():
	var num_fires = 40
	for i in range(num_fires):
		var fire = fire.instantiate()
		var angle = randf() * TAU
		var distance = randf() * damage_radius
		var offset = Vector2(cos(angle), sin(angle)) * distance
		fire.global_position = global_position + offset
		get_parent().add_child(fire)
		
		fire.get_node("Timer").wait_time = 10.0
		fire.get_node("Timer").start()

func _on_timer_timeout():
	queue_free()
