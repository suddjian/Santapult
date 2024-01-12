extends Button

@export var label_color_hover: Color
@onready var label: Label = $"../ShopLabel"
@onready var label_color_default = label.label_settings.font_color

func _on_mouse_entered():
	label.label_settings.font_color = label_color_hover


func _on_mouse_exited():
	label.label_settings.font_color = label_color_default


func _on_pressed():
	get_tree().change_scene_to_file("res://scenes/Shop.tscn")
