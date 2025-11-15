extends CharacterBody2D

@export var speed = 400
var base_speed = 400
var slow_sources = []

func _ready():
	#add_to_group("player")
	pass

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
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
