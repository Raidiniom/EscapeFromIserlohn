# walk_state.gd
extends State

@export var stop_speed: float = 20.0

func enter():
	owner.is_sprinting = false
	# play walk animation if needed
	owner.play_anim("Walk")
	

func physics_process(delta: float) -> void:
	# Gravity
	if not owner.is_on_floor():
		owner.velocity.y -= owner.gravity * delta

	# Input
	var input_dir_2d: Vector2 = Input.get_vector("left", "right", "forward", "backward")
	var input_dir: Vector3 = Vector3(input_dir_2d.x, 0.0, input_dir_2d.y)
	var direction: Vector3 = (owner.global_transform.basis * input_dir).normalized()

	var walk_speed: float = owner.movement_speed

	if direction != Vector3.ZERO:
		owner.velocity.x = direction.x * walk_speed
		owner.velocity.z = direction.z * walk_speed
	else:
		# No input → stop horizontal movement
		owner.velocity.x = 0.0
		owner.velocity.z = 0.0
	
	# Jump
	var wants_jump : bool = Input.is_action_just_pressed("jump") or owner.jump_buffered
	owner.jump_buffered = false
	if wants_jump and owner.is_on_floor():
		owner.velocity.y = owner.jump_impulse
	
	var wants_plant : bool = Input.is_action_just_pressed("plant") or owner.plant_buffered
	owner.plant_buffered = false
	if wants_plant:
		if owner.can_plant() and GameDataManager.seeds[owner.selected_seed] > 0:
			state_machine.change_state("planting")
	
	# Transitions
	if direction == Vector3.ZERO:
		state_machine.change_state("idle")
	elif Input.is_action_pressed("sprint"):
		state_machine.change_state("run")

	owner.move_and_slide()
