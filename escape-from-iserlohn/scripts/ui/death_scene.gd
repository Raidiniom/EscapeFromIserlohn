# death_scene.gd
extends Control

func _ready():
	hide() # start hidden

func _on_respawn_pressed() -> void:
	GameManager.reset_run()
	DeathManager.respawn()

func _on_exit_pressed() -> void:
	GameManager.reset_run()
	DeathManager.exit_to_menu("res://scenes/ui/main_menu.tscn")
