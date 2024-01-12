extends RigidBody2D
class_name Santa
signal shot

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		print("bang")
		shot.emit()

func bounce(power: float):
	var current_speed := 
