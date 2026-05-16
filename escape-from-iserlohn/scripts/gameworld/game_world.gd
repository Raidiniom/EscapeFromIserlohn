extends Node3D

@onready var battle_sound = $Battle

func _ready() -> void:
	print("Starting Game")
	battle_sound.play()
	battle_sound.finished.connect(loop_music)
	DeathManager.death_ui = $UI/DeathScene
	DeathManager.player = $Player
	GameManager.start_round()

func loop_music():
	battle_sound.play()
