extends StaticBody2D

var health = 100

func take_damage():
	health -= 10
	print("Core Health ", health)
	if health <= 10:
		game_over()
		
func game_over():
	print("GAME OVER")
	get_tree().paused = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
