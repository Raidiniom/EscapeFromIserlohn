extends Node3D

func _ready() -> void:
	print("Starting Game")
	DeathManager.death_ui = $UI/DeathScene
	DeathManager.player = $Player
	GameManager.start_round()
