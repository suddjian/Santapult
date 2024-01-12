extends Node2D
class_name Game

var _weapons = {}
@export var weapons: Array[Weapon] = []:
	set(arr):
		print("setting weapons")
		weapons = arr
		_weapons = arr.reduce(acc_dict, {})
		print("weapons set")
func acc_dict(d, wep):
	d[wep.name] = wep
	return d

const META_STATE_FILE = "user://game_meta_state.tres"

var meta_state: Resource = MetaState.new()
var run_state := RunState.new()
var state = "idle"

func save_meta_state():
	var error = ResourceSaver.save(meta_state, META_STATE_FILE)
	assert(error == OK)

func _ready():
	if ResourceLoader.exists(META_STATE_FILE):
		var saved_state = load(META_STATE_FILE)
		if saved_state != null:
			meta_state = saved_state
	meta_state.changed.connect(save_meta_state)
	Global.santa_in_chimney.connect(_on_santa_in_chimney)

func _unhandled_input(event):
	if event.is_action_pressed("shoot") and state == "playing":
		if true:
			print("bang")
			shoot(get_global_mouse_position())
		else:
			print("click")
			%DryFire.play()
	elif event.is_action_pressed("fire_cannon") and state == "idle":
		%CannonBody.counting_down = true
		%PowerMeter.visible = true
	elif event.is_action_released("fire_cannon") and state == "idle" and %CannonBody.counting_down:
		print("FIRE")
		%CannonSound.play()
		var santa = %Santa
		%CannonMouth.remote_path = ""
		santa.freeze = false
		var power = (100*%CannonBody.power_level) ** 2
		var launchvec = Vector2.RIGHT.rotated(%CannonBody.rotation) * (5000 * %CannonBody.power_level ** 2 + 1000)
		santa.launch(launchvec)
		%Camera2D.following = santa
		%CannonBody.counting_down = false
		var tween = get_tree().create_tween()
		AudioServer.set_bus_bypass_effects(AudioServer.get_bus_index("Music"), true)
		tween.tween_property(%Music, "pitch_scale", 1, .5)
#		%Music.pitch_scale = 1
		state = "playing"

var cannon_speed = 0.5

func _process(delta):
	if state == "idle" and Input.is_action_pressed("rotate_ccw"):
		%CannonBody.rotation -= delta * cannon_speed
	if state == "idle" and Input.is_action_pressed("rotate_cw"):
		%CannonBody.rotation += delta * cannon_speed

func shoot(where):
	%PistolSound.play()
	run_state.ammo -= 1;
	var pos = %Santa/CollisionShape2D.global_position
	var shape := %Santa/CollisionShape2D.shape as CircleShape2D
	var hit_santa = Geometry2D.is_point_in_circle(where, pos, shape.radius)
	if hit_santa:
		# shoot santa
		var weapon: Weapon = _weapons[run_state.current_weapon]
		%Santa.bounce(weapon.power)
		await get_tree().create_timer(0.1).timeout
		%Santa/BounceSound.play()

func _on_santa_landed():
	# add stats to meta, reset level
	print("landed")
	state = "landed"

func _on_santa_in_chimney():
	print("down the chimney!")
	state = "landed"
#	%Santa.freeze = true # less fun, set deferred anyway
	%Santa.linear_velocity = Vector2.ZERO
	%Santa.angular_velocity = 0
	var meters = round((%Santa.global_position.x - %CannonMouth.global_position.x) / 100)
	%MetersLabel.text = "%s meters" % meters
	get_tree().create_tween().tween_property(%MetersLabel, "modulate", Color.WHITE, 1.0)
