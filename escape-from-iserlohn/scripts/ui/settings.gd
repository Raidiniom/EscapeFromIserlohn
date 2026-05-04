# scenes/ui/settings.gd
extends Control

# References to the buttons in ButtonContainer
@onready var forward_button = $LabelContainer/Button
@onready var backward_button = $LabelContainer/Button2
@onready var left_strafe_button = $LabelContainer/Button3
@onready var right_strafe_button = $LabelContainer/Button4
@onready var interact_button = $LabelContainer/Button5

# Mapping between buttons and actions
var button_action_map: Dictionary = {}
var waiting_for_action: String = ""

func _ready():
	PauseManager.settings_menu = self
	hide()
	# Map buttons to their actions
	button_action_map = {
		forward_button: "forward",
		backward_button: "backward",
		left_strafe_button: "left",
		right_strafe_button: "right",
		interact_button: "interact"
	}
	
	# Connect button signals
	forward_button.pressed.connect(_on_keybind_button_pressed.bind(forward_button, "forward"))
	backward_button.pressed.connect(_on_keybind_button_pressed.bind(backward_button, "backward"))
	left_strafe_button.pressed.connect(_on_keybind_button_pressed.bind(left_strafe_button, "left"))
	right_strafe_button.pressed.connect(_on_keybind_button_pressed.bind(right_strafe_button, "right"))
	interact_button.pressed.connect(_on_keybind_button_pressed.bind(interact_button, "interact"))
	
	# Update all button labels with current keybinds
	await get_tree().process_frame
	update_all_button_labels()

func update_all_button_labels():
	forward_button.text = SettingsManager.get_keybind_string("forward")
	backward_button.text = SettingsManager.get_keybind_string("backward")
	left_strafe_button.text = SettingsManager.get_keybind_string("left")
	right_strafe_button.text = SettingsManager.get_keybind_string("right")
	interact_button.text = SettingsManager.get_keybind_string("interact")

func _on_keybind_button_pressed(button: Button, action: String):
	if waiting_for_action != "":
		return  # Already waiting for input
	
	waiting_for_action = action
	button.text = "Press any key..."
	button.grab_focus()
	
	# Disable other buttons while waiting
	set_buttons_disabled(true)
	button.disabled = false  # Keep this button enabled for visual feedback

func set_buttons_disabled(disabled: bool):
	forward_button.disabled = disabled
	backward_button.disabled = disabled
	left_strafe_button.disabled = disabled
	right_strafe_button.disabled = disabled
	interact_button.disabled = disabled

func _unhandled_input(event):
	if waiting_for_action == "":
		return
	
	if event is InputEventKey and event.pressed:
		# Don't allow Escape key to be bound (used for menus)
		if event.physical_keycode == KEY_ESCAPE:
			cancel_keybind_input()
			get_viewport().set_input_as_handled()
			return
		
		# Check for duplicate keybind
		if SettingsManager.is_key_used(event.physical_keycode, waiting_for_action):
			show_duplicate_warning(waiting_for_action, event.physical_keycode)
			cancel_keybind_input()
			get_viewport().set_input_as_handled()
			return
		
		# Set the new keybind
		SettingsManager.set_keybind(waiting_for_action, event.physical_keycode)
		
		# Update all button labels (in case of key swap)
		update_all_button_labels()
		
		# Reset UI state
		reset_waiting_state()
		get_viewport().set_input_as_handled()
	
	elif event is InputEventMouseButton and event.pressed:
		if waiting_for_action != "":
			cancel_keybind_input()

func show_duplicate_warning(action: String, keycode: int):
	var key_name = OS.get_keycode_string(keycode)
	var action_display = action.replace("_", " ").capitalize()
	print("Warning: %s is already bound to %s" % [key_name, action_display])
	# You can also show a popup dialog here

func cancel_keybind_input():
	if waiting_for_action != "":
		update_all_button_labels()
		reset_waiting_state()

func reset_waiting_state():
	waiting_for_action = ""
	set_buttons_disabled(false)

func _on_confirm_pressed() -> void:
	SettingsManager.save_settings()
	print("Settings saved!")
	# Optional: Show a brief "Saved!" message

func _on_reset_pressed() -> void:
	# Reset to default keybinds
	var defaults = {
		"left": KEY_A,
		"right": KEY_D,
		"forward": KEY_W,
		"backward": KEY_S,
		"interact": KEY_E
	}
	
	for action in defaults.keys():
		SettingsManager.set_keybind(action, defaults[action])
	
	update_all_button_labels()
	print("Settings reset to defaults!")

func _on_back_pressed() -> void:
	# Cancel keybind input
	if waiting_for_action != "":
		cancel_keybind_input()

	PauseManager.back_to_pause()
