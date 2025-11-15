extends Node2D

var speed = 600
var direction = Vector2.ZERO
#var booom = preload("res://Scenes/explosion.tscn")
var booom = preload("res://Scenes/retro_explosion.tscn")

func _ready():
	direction = (get_global_mouse_position() - global_position).normalized()

func _process(delta):
	global_position += direction * speed * delta

func  explode():
	var explosion = booom.instantiate()
	explosion.global_position = global_position
	get_parent().add_child(explosion)
	queue_free()

func _on_area_2d_body_entered(body):
	if body.name != "Player" and body.name != "Core":
		explode()

func _on_time_explode_timeout():
	explode()
