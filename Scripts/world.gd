extends Node2D

@export var fire = preload("res://Scenes/fire.tscn")
@export var virus = preload("res://Scenes/virus.tscn")
@export var slow_virus = preload("res://Scenes/slow_virus.tscn")
@export var speed_virus = preload("res://Scenes/speed_virus.tscn")

var screen_size = Vector2.ZERO
var ddos_activate = false
var spawn_multiplier = 1

func _ready():
	screen_size = get_viewport_rect().size
	$Timer.start()
	$SpawnTime.start()
	$DDOSTime.start()
	
	$core.global_position = screen_size / 2
	
func _process(delta):
	#print("Active: ", GameManager.active_speed_buff_enemies)
	if ddos_activate:
		$Finish.start()
	pass

func fire_spawn():
	#var player_pos = $Player.global_position
	var obj = fire.instantiate()
	obj.global_position = $Player.global_position 
	obj.damage = 3
	add_child(obj)
	
func virus_spawn():
	for i in range(spawn_multiplier):
		var rand_normal_enemy = 0 if randf() < 0.8 else 1
		var rand_slow_enemy = 0 if randf() < 0.3 else 1
		var rand_speed_enemy = 0 if randf() < 0.3 else 0
		
		if rand_normal_enemy == 0:
			var enemy = virus.instantiate()
			enemy.global_position = get_random_edge_position()
			add_child(enemy)
		if rand_slow_enemy == 0:
			var enemy = slow_virus.instantiate()
			enemy.global_position = get_random_edge_position()
			add_child(enemy)
		if rand_speed_enemy == 0:
			var enemy = speed_virus.instantiate()
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

func _on_ddos_time_timeout():
	ddos_warning()
	
	ddos_activate = true
	spawn_multiplier = 5
	$SpawnTime.wait_time = 0.5
	
func ddos_warning():
	# Tạo warning label
	var canvas_layer = CanvasLayer.new()
	canvas_layer.name = "DDOSWarning"
	canvas_layer.layer = 100
	
	var label = Label.new()
	label.text = "DDOS INCOMING"
	
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	var fv = FontVariation.new()
	fv.base_font = load("res://Assets/Font/VT323-Regular.ttf")
	fv.variation_embolden = 1.2
	label.add_theme_font_override("font", fv)
	
	# Style chữ đỏ lớn
	label.add_theme_font_size_override("font_size", 120)
	label.add_theme_color_override("font_color", Color.RED)
	
	# Đặt ở giữa màn hình
	label.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	label.grow_horizontal = Control.GROW_DIRECTION_BOTH
	label.grow_vertical = Control.GROW_DIRECTION_BOTH
	
	canvas_layer.add_child(label)
	get_tree().root.add_child(canvas_layer)
	
	# Hiệu ứng nhấp nháy
	flash_warning(label, canvas_layer)

func flash_warning(label: Label, canvas_layer: CanvasLayer):
	var flash_count = 6  # Nhấp nháy 6 lần
	
	for i in range(flash_count):
		label.visible = true
		await get_tree().create_timer(0.3).timeout
		label.visible = false
		await get_tree().create_timer(0.2).timeout
	
	# Xóa warning sau khi nhấp nháy xong
	canvas_layer.queue_free()
	
func _on_finish_timeout():
	print("You Win")
	pass # Replace with function body.
