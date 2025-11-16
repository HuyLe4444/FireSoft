extends Node2D

@export var fire = preload("res://Scenes/fire.tscn")
@export var virus = preload("res://Scenes/virus.tscn")
@export var slow_virus = preload("res://Scenes/slow_virus.tscn")
@export var speed_virus = preload("res://Scenes/speed_virus.tscn")

var screen_size = Vector2(1152, 648)

func _ready():
	$Timer.start()
	$SpawnTime.start()
	
func _process(delta):
	print("Active: ", GameManager.active_speed_buff_enemies)

func fire_spawn():
	#var player_pos = $Player.global_position
	var obj = fire.instantiate()
	obj.global_position = $Player.global_position 
	obj.damage = 3
	add_child(obj)
	
func virus_spawn():
	var rand_normal_enemy = 0 if randf() < 0.8 else 1
	var rand_slow_enemy = 0 if randf() < 1 else 1
	var rand_speed_enemy = 0 if randf() < 0.3 else 1
	
	#if rand_normal_enemy == 0:
		#var enemy = virus.instantiate()
		#enemy.global_position = get_random_edge_position()
		#add_child(enemy)
	if rand_slow_enemy == 0:
		var enemy = slow_virus.instantiate()
		enemy.global_position = get_random_edge_position()
		add_child(enemy)
	#if rand_speed_enemy == 0:
		#var enemy = speed_virus.instantiate()
		#enemy.global_position = get_random_edge_position()
		#add_child(enemy)
	
	
func get_random_edge_position():
	var edge = randi() % 4
	var pos = Vector2.ZERO
	
	match edge:
		0:  # Top
			pos = Vector2(randf_range(0, screen_size.x), -50)
		1:  # Bottom
			pos = Vector2(randf_range(0, screen_size.x), screen_size.y + 50)
		2:  # Left
			pos = Vector2(-50, randf_range(0, screen_size.y))
		3:  # Right
			pos = Vector2(screen_size.x + 50, randf_range(0, screen_size.y))
	return pos

func _on_timer_timeout():
	fire_spawn()

func _on_spawn_time_timeout():
	virus_spawn()
