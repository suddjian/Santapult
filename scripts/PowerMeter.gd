extends Node

@export var colors: Gradient

func set_power_level(power_level):
	var color = colors.sample(power_level)
	var height = %Wrapper.custom_minimum_size.y * power_level
	%ColorBox.custom_minimum_size.y = height
	%ColorBox.color = color
	%Wrapper.custom_minimum_size.x 
