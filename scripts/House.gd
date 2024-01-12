extends Node2D


func _on_chimney_body_entered(body):
	if body is Santa:
		Global.santa_in_chimney.emit()
