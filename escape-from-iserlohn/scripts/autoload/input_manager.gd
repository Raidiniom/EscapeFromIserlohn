# input_manager.gd
extends Node

enum ControlScheme { KEYBOARD, MOBILE }

var current_scheme: ControlScheme = ControlScheme.KEYBOARD

signal scheme_changed(new_scheme)

func _ready() -> void:
	detect_scheme()

func detect_scheme() -> void:
	var os_name = OS.get_name()
	if os_name == "Android" or os_name == "iOS":
		set_scheme(ControlScheme.MOBILE)
	else:
		set_scheme(ControlScheme.KEYBOARD)

func set_scheme(scheme: ControlScheme) -> void:
	if current_scheme == scheme:
		return
	current_scheme = scheme
	emit_signal("scheme_changed", scheme)

func is_mobile() -> bool:
	return current_scheme == ControlScheme.MOBILE
