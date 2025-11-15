extends CharacterBody2D

var health = 4
var speed = 100
var target = null

func _ready():
	target = get_tree().get_first_node_in_group("core")

func _physics_process(delta):
	if target:
		var direction = (target.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

func take_damage():
	print("burn")
	health -= 1
	if health == 0:
		queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("core"):
		body.take_damage()
		queue_free()
