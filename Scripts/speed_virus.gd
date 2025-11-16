extends CharacterBody2D

var health = 5
var speed = 100
var base_speed = 100
var target = null
var is_casting = false
var has_cast = false
var is_frozen = false
#var bonus_speed = 0
#var buffed_enemies = []

func _ready():
	speed = speed + (GameManager.active_speed_buff_enemies * 50)
	target = get_tree().get_first_node_in_group("core")
	add_to_group("enemy")

func _physics_process(delta):
	if target and not is_casting and not has_cast and not is_frozen:
		var distance = global_position.distance_to(target.global_position)
		
		if distance <= 300:
			start_casting()
		else:
			var direction = (target.global_position - global_position).normalized()
			velocity = direction * speed
			move_and_slide()
			
func start_casting():
	is_casting = true
	velocity = Vector2.ZERO
	$CastTime.start()

func take_damage():
	health -= 1
	if health <= 0:
		#for enemy in buffed_enemies:
			#if is_instance_valid(enemy) and enemy.has_method("erase_buff"):
				#enemy.erase_buff(self)
		if has_cast:
			GameManager.active_speed_buff_enemies -= 1
			for enemy in get_tree().get_nodes_in_group("enemy"):
				if enemy != self and enemy.has_method("erase_buff"):
					enemy.erase_buff(self)
		
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

func _on_cast_time_timeout():
	is_casting = false
	has_cast = true
	apply_speed_up()
	
func apply_speed_up():
	GameManager.active_speed_buff_enemies += 1
	#buffed_enemies.clear()
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy != self and enemy.has_method("add_speed"):
			enemy.add_speed(self)
			#buffed_enemies.append(enemy)

func add_speed(source):
	speed = base_speed + (GameManager.active_speed_buff_enemies * 50)
	
func erase_buff(source):
	speed = base_speed + (GameManager.active_speed_buff_enemies * 50)
	if speed <= base_speed:
		speed = base_speed

