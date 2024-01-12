extends RigidBody2D
class_name Santa

signal shot
signal landed

@onready var current_sprite: Sprite2D = $Sprites.get_child(0)

func bounce(power: float, min: float = 0.0):
	var height = global_position.y - %Floor.global_position.y
	var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * gravity_scale
	var gravpot = (2.0 * abs(gravity * height)) ** 0.4 # not physically accurate lol, should be sqrt
	var velocities = (Vector2(linear_velocity.x + 1, - (abs(linear_velocity.y)**.8) - gravpot - 1))
	var power_adjusted = power/(.0001*velocities.length() + 1.0)
	var new_velocity = power_adjusted * Vector2(abs(velocities.x), velocities.y)
	var half_x = (new_velocity.x - linear_velocity.x) / 2
	new_velocity.x -= half_x
	new_velocity.y -= half_x
	linear_velocity = new_velocity
	angular_velocity = randf_range(-3, 3)
	change_sprite()

func launch(force: Vector2):
	linear_velocity += force
	angular_velocity = angular_velocity + randf_range(-3, 3)

func _physics_process(delta):
	angular_velocity = clamp(angular_velocity, -8, 8)

func _on_sleeping_state_changed():
	if (sleeping):
		landed.emit()

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	$BounceSound.play()
	change_sprite()


func change_sprite():
	current_sprite.visible = false
	var i = current_sprite.get_index()
	var r = randi_range(0, $Sprites.get_child_count() - 2)
	if r >= i:
		r+=1
	current_sprite = $Sprites.get_child(r)
	current_sprite.visible = true
