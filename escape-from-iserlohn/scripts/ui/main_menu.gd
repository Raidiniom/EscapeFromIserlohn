extends Control

@onready var menu_sound = $Menu

func _ready() -> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	menu_sound.play()
	menu_sound.finished.connect(_on_menu_finished)
	

func _on_menu_finished() -> void:
	menu_sound.play()

func _on_play_pressed() -> void:
	
	GameManager.reset_run()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	menu_sound.stop()
	
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://scenes/game_world.tscn")

func _on_settings_pressed() -> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://scenes/ui/settings_menu.tscn")

func _on_quit_pressed() -> void:
	menu_sound.stop()
	get_tree().quit()
