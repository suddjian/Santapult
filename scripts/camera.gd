extends Camera2D

@export var pan_speed := 1.0
@export var following: Node2D
@export var follow_strength := 10.0
@export var max_distance := 600

var inter_vel := Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#position += Input.get_vector("left", "right", "up", "down") * delta * pan_speed
	if following != null:
		var target_pos = following.global_position
		var tolerance = max_distance
		if "linear_velocity" in following:
			var vel = following.linear_velocity / 10
			var vel_bias = Vector2(
				clamp(vel.x, -400, 400),
				clamp(vel.y, -300, 300)
			)
			inter_vel = approach(inter_vel, vel_bias, max_distance, delta)
			target_pos += inter_vel
			tolerance = min(max_distance, (vel - inter_vel).length())
#		var course = (target_pos - global_position) * follow_strength * delta
#		var new_pos = global_position + course
#		var new_diff = target_pos - new_pos
		global_position = target_pos

func approach(cam, target, tolerance, delta):
	var course = (target - cam) * follow_strength * delta
	var new_cam = cam + course
	var remaining = target - new_cam
	if remaining.length() > tolerance:
		new_cam += remaining - remaining.limit_length(tolerance)
	return new_cam
	
