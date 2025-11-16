extends Control

func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world.tscn")


func _on_button_3_pressed() -> void:
	get_tree().quit()
