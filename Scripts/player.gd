extends CharacterBody2D

@export var bomb = preload("res://Scenes/bomb.tscn")
@export var flame = preload("res://Scenes/flame.tscn")
@export var speed = 400
var base_speed = 400
var slow_sources = []
var energy = 0
var max_energy = 100

var is_flamethrowing = false
var flamethrower_timer = 0.0
var flame_spawn = 0.0

func _ready():
	#add_to_group("player")
	pass

func get_input():
	look_at(get_global_mouse_position())
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	print("Energy: ", energy)
	get_input()
	move_and_slide()
	
	if is_flamethrowing:
		flamethrower_timer -= delta
		flame_spawn -= delta
		
		if flame_spawn <= 0:
			flame_cone()
			flame_spawn = 0.05
		
		if flamethrower_timer <= 0:
			is_flamethrowing = false

func add_slow(source):
	if source not in slow_sources:
		slow_sources.append(source)
		update_speed()

func remove_slow(source):
	if source in slow_sources:
		slow_sources.erase(source)
		update_speed()
		
func update_speed():
	if slow_sources.size() > 0:
		speed = base_speed * pow(0.7, slow_sources.size())
	else:
		speed = base_speed
		
func add_energy(amount):
	energy += amount
	if energy >= max_energy:
		energy = max_energy
		
func _input(event):
	if event.is_action_pressed("mouse_left"):
		#if energy >= 20:
			#energy -= 20
		fire_bomb()
	
	if event.is_action_pressed("mouse_right") and not is_flamethrowing:
		#if energy >= 30:
			#energy -= 30
		is_flamethrowing = true
		flamethrower_timer = 5.0
		flame_spawn = 0.0
		
func fire_bomb():
	var bomb_instance = bomb.instantiate()
	bomb_instance.global_position = global_position
	get_parent().add_child(bomb_instance)

func flame_cone():
	var mouse_pos = get_global_mouse_position()
	var base_direction = (mouse_pos - global_position).normalized()
	
	var cone_angle = deg_to_rad(60)
	var num_flames = 5
	
	for i in range(num_flames):
		var flame_instance = flame.instantiate()
		
		var random_angle = randf_range(-cone_angle/2, cone_angle/2)
		var flame_direction = base_direction.rotated(random_angle)
		
		flame_instance.global_position = global_position + flame_direction * 30
		flame_instance.direction = flame_direction
		flame_instance.rotation = flame_direction.angle()
		flame_instance.speed = randf_range(700, 900)
		
		get_parent().add_child(flame_instance)
	
