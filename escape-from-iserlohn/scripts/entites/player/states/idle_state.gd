extends State

func enter():
	# Play idle animation here
	print("Player Idle State")

func physics_process(delta):
	# Apply gravity even when idle to keep the player on the ground
	if not owner.is_on_floor():
		owner.velocity.y -= owner.gravity * delta

	# Check for transition conditions
	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_dir.y = Input.get_action_strength("backward") - Input.get_action_strength("forward")
	
	if input_dir != Vector2.ZERO:
		if owner.movement_speed > 12:
			state_machine.change_state("run")
		else:
			state_machine.change_state("walk")
	elif Input.is_action_just_pressed("plant"):
		print("pressed plant key!")
		if owner.can_plant():
			state_machine.change_state("planting")

	owner.move_and_slide()
