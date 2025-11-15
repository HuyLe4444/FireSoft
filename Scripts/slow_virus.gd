extends CharacterBody2D

var health = 2
var speed = 100
var target = null
var is_casting = false
var has_cast = false

func _ready():
	target = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if target and not is_casting and not has_cast:
		var distance = global_position.distance_to(target.global_position)
		
		if distance <= 200:
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
	if health == 0:
		if target and target.has_method("remove_slow"):
			target.remove_slow(self)
		queue_free()

func _on_cast_time_timeout():
	is_casting = false
	has_cast = true
	apply_slow()
	
func apply_slow():
	if target and target.has_method("add_slow"):
		target.add_slow(self)
