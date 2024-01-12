extends Node2D
class_name Game
var meta_state: Resource = MetaState.new()
var run_state: Resource = RunState.new()
const META_STATE_FILE = "user://game_meta_state.tres"

func autosave_meta_state():
	var error = ResourceSaver.save(meta_state, META_STATE_FILE)
	assert(error == OK)

func _ready():
	if ResourceLoader.exists(META_STATE_FILE):
		var saved_state = load(META_STATE_FILE)
		if saved_state != null:
			meta_state = saved_state
	meta_state.changed.connect(autosave_meta_state)

func _on_santa_shot():
	if run_state.current_weapon.ammo > 0:
		print("ouch")
		# shoot santa
		run_state.current_weapon.ammo -= 1;
		%Santa.bounce(run_state.current_weapon.power)
	else:
		print("click")
		# click
