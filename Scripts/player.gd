extends CharacterBody2D

@export var bomb = preload("res://Scenes/bomb.tscn")
@export var speed = 400
var base_speed = 400
var slow_sources = []
var energy = 0
var max_energy = 100

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
		if energy >= 20:
			energy -= 20
			fire_bomb()
		
func fire_bomb():
	var bomb_instance = bomb.instantiate()
	bomb_instance.global_position = global_position
	get_parent().add_child(bomb_instance)
	
