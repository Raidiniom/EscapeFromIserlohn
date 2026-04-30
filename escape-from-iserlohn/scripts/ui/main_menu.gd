extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game_world.tscn")

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/settings_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
