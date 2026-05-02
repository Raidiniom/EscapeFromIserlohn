extends Control

func _ready() -> void:
	PauseManager.pause_menu = self
	hide()

func _on_resume_pressed() -> void:
	PauseManager.resume()

func _on_settings_pressed() -> void:
	PauseManager.open_settings()
	print("Open settings menu")

func _on_exit_pressed() -> void:
	print("EXIT PRESSED")
	PauseManager.go_to_menu("res://scenes/ui/main_menu.tscn")
