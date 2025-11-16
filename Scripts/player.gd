extends CharacterBody2D

@export var bomb = preload("res://Scenes/bomb.tscn")
@export var flame = preload("res://Scenes/flame.tscn")
@export var speed = 500

var time_stop_active = false
var frozen_enemies = []

var base_speed = 500
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
		if energy >= 00:
			energy -= 00
			fire_bomb()
	
	if event.is_action_pressed("mouse_right") and not is_flamethrowing:
		if energy >= 00:
			energy -= 00
			is_flamethrowing = true
			flamethrower_timer = 5.0
			flame_spawn = 0.0
	
	if event.is_action_pressed("key_E") and not time_stop_active:
		if energy >= 00:
			energy -=00
			time_stop_active = true
			
			time_stop_effect()
			enemy_frozen()
			
			await get_tree().create_timer(2.0).timeout
			
			end_time_stop()
		
func fire_bomb():
	var bomb_instance = bomb.instantiate()
	bomb_instance.global_position = global_position
	get_parent().add_child(bomb_instance)

func flame_cone():
	var mouse_pos = get_global_mouse_position()
	var base_direction = (mouse_pos - global_position).normalized()
	
	var cone_angle = deg_to_rad(60)
	var num_flames = 3
	
	for i in range(num_flames):
		var flame_instance = flame.instantiate()
		
		var random_angle = randf_range(-cone_angle/2, cone_angle/2)
		var flame_direction = base_direction.rotated(random_angle)
		
		flame_instance.global_position = global_position + flame_direction * 10
		flame_instance.direction = flame_direction
		flame_instance.rotation = flame_direction.angle()
		flame_instance.speed = randf_range(1000, 1200)
		
		get_parent().add_child(flame_instance)

func time_stop_effect():
	var canvas_layer = CanvasLayer.new()
	canvas_layer.name = "TimeStopEffect"
	canvas_layer.layer = 100
	
	var color_rect = ColorRect.new()
	color_rect.name = "ColorOverlay"
	#color_rect.color = Color(0.8, 0.6, 0.2, 0.4)
	color_rect.color = Color(1.0, 0.8, 0.0, 0.3)
	color_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	canvas_layer.add_child(color_rect)
	get_tree().root.add_child(canvas_layer)
	
func enemy_frozen():
	frozen_enemies.clear()
	
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy.has_method("freeze"):
			var original_speed = enemy.speed
			frozen_enemies.append({"enemy": enemy, "original_speed": original_speed})
			enemy.freeze()
	
func end_time_stop():
	var effect = get_tree().root.get_node_or_null("TimeStopEffect")
	if effect:
		effect.queue_free()
	
	for enemy in frozen_enemies:
		if is_instance_valid(enemy["enemy"]):
			enemy["enemy"].unfreeze(enemy["original_speed"])
	
	frozen_enemies.clear()
	time_stop_active = false
	
