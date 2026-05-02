extends State

@export var walk_speed: float = 5.0

func enter():
	# Play animation here
	pass

func physics_process(delta):
	# Apply gravity
	if not owner.is_on_floor():
		owner.velocity.y -= owner.gravity * delta

	# Get movement input
	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_dir.y = Input.get_action_strength("backward") - Input.get_action_strength("forward")
	var direction = (owner.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		owner.velocity.x = direction.x * owner.movement_speed
		owner.velocity.z = direction.z * owner.movement_speed
	else:
		owner.velocity.x = move_toward(owner.velocity.x, 0, owner.movement_speed)
		owner.velocity.z = move_toward(owner.velocity.z, 0, owner.movement_speed)

	# Transition logic
	if direction == Vector3.ZERO:
		state_machine.change_state("idle")
	elif owner.movement_speed > 12:
		state_machine.change_state("run")
	
	owner.move_and_slide()
