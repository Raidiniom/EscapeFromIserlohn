extends Node

const SETTINGS_PATH = "user://settings.cfg"

var keybinds: Dictionary = {
	"strafe_left": KEY_A,
	"strafe_right": KEY_D,
	"forward": KEY_W,
	"backward": KEY_S,
	"interact": KEY_E
}

func _ready():
	load_settings()
	apply_keybinds_to_input_map()

func load_settings():
	var config = ConfigFile.new()
	if config.load(SETTINGS_PATH) == OK:
		for action in keybinds.keys():
			keybinds[action] = config.get_value("keybinds", action, keybinds[action])

func save_settings():
	var config = ConfigFile.new()
	for action in keybinds.keys():
		config.set_value("keybinds", action, keybinds[action])
	config.save(SETTINGS_PATH)

func apply_keybinds_to_input_map():
	# Clear existing mappings for our actions
	for action in keybinds.keys():
		if InputMap.has_action(action):
			InputMap.action_erase_events(action)
		else:
			InputMap.add_action(action)
		
		# Add the key as an input event
		var event = InputEventKey.new()
		event.keycode = keybinds[action]
		InputMap.action_add_event(action, event)

func set_keybind(action: String, keycode: int):
	if action in keybinds:
		keybinds[action] = keycode
		apply_keybinds_to_input_map()
		save_settings()

func get_keybind_string(action: String) -> String:
	var keycode = keybinds.get(action, KEY_NONE)
	return OS.get_keycode_string(keycode)
