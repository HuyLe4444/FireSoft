extends Node2D

@export var fire = preload("res://Scenes/fire.tscn")
@export var virus = preload("res://Scenes/virus.tscn")

var screen_size = Vector2(1152, 648)

func _ready():
	$Timer.start()
	$SpawnTime.start()
	
func fire_spawn():
	#var player_pos = $Player.global_position
	var obj = fire.instantiate()
	obj.global_position = $Player.global_position 
	add_child(obj)
	
func virus_spawn():
	var enemy = virus.instantiate()
	enemy.global_position = get_random_edge_position()
	add_child(enemy)
	
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
