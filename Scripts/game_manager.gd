extends Node

var active_speed_buff_enemies = 0

func _process(delta):
	if active_speed_buff_enemies <= 0:
		active_speed_buff_enemies = 0
