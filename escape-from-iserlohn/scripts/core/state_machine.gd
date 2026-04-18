# StateMachine.gd
extends Node
class_name StateMachine

@export var initial_state: NodePath # Assign your Idle node in the inspector

var current_state: State
var states: Dictionary = {}

func _ready():
	# Cache references to all state child nodes
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_machine = self
			child.player = get_parent() # Assumes player is the parent of StateMachine

	# Start the FSM
	if initial_state:
		current_state = get_node(initial_state)
		current_state.enter()
	else:
		push_error("Initial state not set for StateMachine!")

func _process(delta):
	if current_state:
		current_state.process(delta)

func _physics_process(delta):
	if current_state:
		current_state.physics_process(delta)

# Function to change states
func change_state(new_state_name: String):
	var new_state = states.get(new_state_name.to_lower())
	if not new_state:
		push_error("State '" + new_state_name + "' not found!")
		return

	if current_state:
		current_state.exit()

	current_state = new_state
	current_state.enter()
