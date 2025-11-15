extends Area2D

var speed = 800
var direction = Vector2.ZERO
var damage = 1

func _ready():
	$Timer.start()

func _process(delta):
	global_position += direction * delta * speed
	
func _on_timer_timeout():
	queue_free()

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()
