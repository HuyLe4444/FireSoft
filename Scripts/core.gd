extends StaticBody2D

var health = 100

func take_damage():
	health -= 5
	print("Core Health ", health)
	if health <= 10:
		game_over()
		
func game_over():
	get_tree().change_scene_to_file("res://Scenes/lose.tscn")
	#get_tree().paused = true
