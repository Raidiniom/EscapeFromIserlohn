# death_scene.gd
extends Control

func _ready():
	hide() # start hidden

func _on_respawn_pressed() -> void:
	DeathManager.respawn()

func _on_exit_pressed() -> void:
	DeathManager.exit_to_menu("res://scenes/ui/main_menu.tscn")
