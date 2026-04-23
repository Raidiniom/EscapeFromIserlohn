extends Control

@onready var forward_button = $LabelContainer/Button
@onready var backward_button = $LabelContainer/Button2
@onready var left_button = $LabelContainer/Button3
@onready var right_button = $LabelContainer/Button4
@onready var interact_button = $LabelContainer/Button5

var waiting_for_action := ""

func _ready():
	# Ensure it is visible when opened as a scene
	show()

	update_all_button_labels()

	forward_button.pressed.connect(func(): start_rebind("forward", forward_button))
	backward_button.pressed.connect(func(): start_rebind("backward", backward_button))
	left_button.pressed.connect(func(): start_rebind("left", left_button))
	right_button.pressed.connect(func(): start_rebind("right", right_button))
	interact_button.pressed.connect(func(): start_rebind("interact", interact_button))


func update_all_button_labels():
	forward_button.text = SettingsManager.get_keybind_string("forward")
	backward_button.text = SettingsManager.get_keybind_string("backward")
	left_button.text = SettingsManager.get_keybind_string("left")
	right_button.text = SettingsManager.get_keybind_string("right")
	interact_button.text = SettingsManager.get_keybind_string("interact")


func start_rebind(action: String, button: Button):
	if waiting_for_action != "":
		return

	waiting_for_action = action
	button.text = "Press any key..."
	button.grab_focus()


func _unhandled_input(event):
	if waiting_for_action == "":
		return

	if event is InputEventKey and event.pressed:
		# prevent escape binding
		if event.physical_keycode == KEY_ESCAPE:
			cancel_rebind()
			return

		SettingsManager.set_keybind(waiting_for_action, event.physical_keycode)
		waiting_for_action = ""
		update_all_button_labels()

	elif event is InputEventMouseButton and event.pressed:
		cancel_rebind()


func cancel_rebind():
	waiting_for_action = ""
	update_all_button_labels()


func _on_reset_pressed() -> void:
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


func _on_confirm_pressed() -> void:
	SettingsManager.save_settings()
	print("Settings saved!")


func _on_back_pressed() -> void:
	# return to main menu scene
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
