extends CharacterBody3D

@export var speed : float = 5.0
@export var gravity : float = 20.0
@export var jump_velocity : float = 8.0

@export_group("Player Keybinds")
@export var strafe_left : String;
@export var strafe_right : String;
@export var forward : String;
@export var backward : String;
@export var interact : String;

var state_machine : Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine = $StateMachine
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	pass
