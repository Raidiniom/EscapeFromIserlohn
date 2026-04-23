extends Node

var is_paused := false
var pause_menu: Control
var settings_menu: Control

func _ready():
	# Make sure input is captured globally
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("esc"):
		toggle_pause()

func toggle_pause():
	is_paused = !is_paused
	
	get_tree().paused = is_paused
	
	if is_paused:
		show_paused()
	else:
		hide_all()

func show_paused():
	if pause_menu:
		pause_menu.show()
	
	if  settings_menu:
		settings_menu.hide()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func open_settings():
	if pause_menu:
		pause_menu.hide()
	
	if  settings_menu:
		settings_menu.show()

func resume():
	is_paused = false
	get_tree().paused = false
	hide_all()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func back_to_pause():
	if settings_menu:
		settings_menu.hide()
	if pause_menu:
		pause_menu.show()

func go_to_menu(scene_path: String):
	is_paused = false
	get_tree().paused = false
	
	hide_all()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	await get_tree().process_frame
	
	get_tree().change_scene_to_file(scene_path)

func hide_all():
	if pause_menu:
		pause_menu.hide()
	if settings_menu:
		settings_menu.hide()
