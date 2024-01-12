extends Node2D

signal power_level_changed(power_level)
@export var min_angle := 4.85
@export var max_angle := 6.25
@export var curve: Curve
@export var counting_down := false
var power_level = 0.0
var t = 0.0

func _process(delta):
	rotation = clamp(fposmod(rotation, TAU), min_angle, max_angle)
	if not counting_down:
		return
	t += delta
	var x = fmod(t, 2)
	if x > 1:
		x = 2 - x
	power_level = clamp(curve.sample(x), 0.0, 1.0)
	power_level_changed.emit(power_level)
