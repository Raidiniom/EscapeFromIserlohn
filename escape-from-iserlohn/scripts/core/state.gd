
class_name State
extends Node

var player : CharacterBody3D
var state_machine : Node

func _ready() -> void:
	player.get_parent().get_parent() as CharacterBody3D
	state_machine = get_parent()

func enter(_msg : Dictionary = {}) -> void:
	pass

func exit() -> void:
	pass

func physics_update(delta : float) -> void:
	pass

func update(delta : float) -> void:
	pass

func handle_input(event : InputEvent) -> void:
	pass
