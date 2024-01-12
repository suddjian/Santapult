extends Marker2D

@export var thingies: Array[Spawnable] = []
var next_spawn_x = pick_next_x()

func pick_next_x():
	return global_position.x + 3000 + randi_range(0, 8000)

func _process(delta):
	if global_position.x > next_spawn_x:
		spawn()

func spawn():
	var thingy: Spawnable = thingies.pick_random()
	var instance := thingy.scene.instantiate()
	$"../..".add_child(instance)
	instance.global_position = global_position
	if thingy.grounded:
		instance.global_position.y = %Floor.global_position.y
	next_spawn_x = pick_next_x()
