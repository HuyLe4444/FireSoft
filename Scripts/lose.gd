extends Control

func _ready() -> void:
	$Label2/Label2.text = ("Score: ") + str(GameManager.point * 100)

func _on_button_2_pressed() -> void:
	GameManager.point = 0
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

func _on_button_3_pressed() -> void:
	get_tree().quit()
