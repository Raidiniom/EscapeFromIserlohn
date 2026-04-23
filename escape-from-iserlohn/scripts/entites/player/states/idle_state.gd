extends State

func enter():
	# Play idle animation here
	print("Entered Idle State")

func physics_process(delta):
	# Apply gravity even when idle to keep the player on the ground
	if not player.is_on_floor():
		player.velocity.y -= player.gravity * delta

	# Check for transition conditions
	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_dir.y = Input.get_action_strength("backward") - Input.get_action_strength("forward")
	if input_dir != Vector2.ZERO:
		state_machine.change_state("walk")
	elif Input.is_action_just_pressed("plant"):
		print("pressed plant key!")
		if player.can_plant():
			state_machine.change_state("planting")

	player.move_and_slide()
