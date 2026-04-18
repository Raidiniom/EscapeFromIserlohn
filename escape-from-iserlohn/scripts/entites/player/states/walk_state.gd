extends State

@export var walk_speed: float = 5.0

func enter():
	# Play animation here
	print("Entered Walk State")

func physics_process(delta):
	# Apply gravity
	if not player.is_on_floor():
		player.velocity.y -= player.gravity * delta

	# Get movement input
	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_dir.y = Input.get_action_strength("backward") - Input.get_action_strength("forward")
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		player.velocity.x = direction.x * walk_speed
		player.velocity.z = direction.z * walk_speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, walk_speed)
		player.velocity.z = move_toward(player.velocity.z, 0, walk_speed)

	# Transition logic
	if direction == Vector3.ZERO:
		state_machine.change_state("idle")
	
	player.move_and_slide()
