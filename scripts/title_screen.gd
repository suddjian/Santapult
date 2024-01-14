extends Node2D

func is_ignored_key(event: InputEvent):
	if not (event is InputEventKey):
		return false
	return event.keycode > KEY_MENU and event.keycode < KEY_LAUNCHMEDIA

func _input(event):
	if (event is InputEventKey or event is InputEventJoypadButton or event is InputEventKey or event is InputEventMouseButton) and not is_ignored_key(event) and event.is_released():
		get_tree().change_scene_to_file("res://scenes/Game.tscn")
