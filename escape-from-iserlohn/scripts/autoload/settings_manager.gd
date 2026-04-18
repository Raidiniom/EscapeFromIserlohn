# scripts/autoload/settings_manager.gd
extends Node

const SETTINGS_PATH = "user://settings.cfg"

# Default keybinds
var keybinds: Dictionary = {
	"left": KEY_A,
	"right": KEY_D,
	"forward": KEY_W,
	"backward": KEY_S,
	"interact": KEY_E
}

# Signal for when keybinds change (optional, for real-time updates)
signal keybinds_changed

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
	var error = config.save(SETTINGS_PATH)
	if error == OK:
		print("Settings saved successfully!")
	else:
		print("Error saving settings: ", error)

func apply_keybinds_to_input_map():
	# Clear and recreate all action mappings
	for action in keybinds.keys():
		if InputMap.has_action(action):
			InputMap.action_erase_events(action)
		else:
			InputMap.add_action(action)
		
		var event = InputEventKey.new()
		event.keycode = keybinds[action]
		InputMap.action_add_event(action, event)
	
	keybinds_changed.emit()

func set_keybind(action: String, keycode: int):
	if action in keybinds:
		keybinds[action] = keycode
		apply_keybinds_to_input_map()
		# Don't auto-save here - wait for Confirm button

func get_keybind_string(action: String) -> String:
	var keycode = keybinds.get(action, KEY_NONE)
	var event := InputEventKey.new()
	event.keycode = keycode
	return event.as_text()

func get_keybind(action: String) -> int:
	return keybinds.get(action, KEY_NONE)

func is_key_used(keycode: int, exclude_action: String = "") -> bool:
	for action in keybinds.keys():
		if action != exclude_action and keybinds[action] == keycode:
			return true
	return false
