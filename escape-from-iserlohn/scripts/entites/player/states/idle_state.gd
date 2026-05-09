extends State

func enter():
	owner.is_sprinting = false
	print("Player Idle State")
	# Play idle animation here

func physics_process(delta: float) -> void:
	# Gravity
	if not owner.is_on_floor():
		owner.velocity.y -= owner.gravity * delta

	# Hard stop horizontally
	owner.velocity.x = 0.0
	owner.velocity.z = 0.0

	# Input for transitions
	var input_dir_2d: Vector2 = Input.get_vector("left", "right", "forward", "backward")

	if input_dir_2d != Vector2.ZERO:
		if Input.is_action_pressed("sprint"):
			state_machine.change_state("run")
		else:
			state_machine.change_state("walk")
	elif Input.is_action_just_pressed("plant"):
		if owner.can_plant() and GameDataManager.seeds[owner.selected_seed] > 0:
			state_machine.change_state("planting")
	
	owner.move_and_slide()
