# State.gd
extends Node
class_name State

# Optional: Reference to the state machine that owns this state
var state_machine: Node
# Essential: Reference to the player (CharacterBody3D)
var player: CharacterBody3D

# Called when this state is entered
func enter() -> void:
	pass

# Called when this state is exited
func exit() -> void:
	pass

# Called every frame; use for non-physics logic like checking for transitions
func process(delta: float) -> void:
	pass

# Called every physics step; use for movement and physics calculations
func physics_process(delta: float) -> void:
	pass
