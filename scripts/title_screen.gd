extends Node2D

func _input(event):
	if event.is_released():
		get_tree().change_scene_to_file("res://scenes/Game.tscn")
