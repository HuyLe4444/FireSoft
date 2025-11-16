extends CharacterBody2D

var health = 10
var speed = 150
var base_speed = 150
var target = null
var is_frozen = false
#var bonus_speed = 0
#var speed_source = []

func _ready():
	speed = speed + (GameManager.active_speed_buff_enemies * 50)
	target = get_tree().get_first_node_in_group("core")
	add_to_group("enemy")

func _physics_process(delta):
	print(speed)
	if target and not is_frozen:
		var direction = (target.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

func take_damage():
	#print("burn")
	health -= 1
	if health <= 0:
		GameManager.point += 10
		var player = get_tree().get_first_node_in_group("player")
		if player and player.has_method("add_energy"):
			player.add_energy(5)
		queue_free()
		
func freeze():
	is_frozen = true
	speed = 0
	velocity = Vector2.ZERO

func unfreeze(original_speed):
	is_frozen = false
	speed = original_speed

func add_speed(source):
	speed = base_speed + (GameManager.active_speed_buff_enemies * 50)
	
func erase_buff(source):
	speed = base_speed + (GameManager.active_speed_buff_enemies * 50)
	if speed <= base_speed:
		speed = base_speed

func _on_area_2d_body_entered(body):
	if body.is_in_group("core"):
		body.take_damage()
		queue_free()
