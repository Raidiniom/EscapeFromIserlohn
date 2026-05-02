extends State

@export var sprint_multiplier: float = 2.0
@export var stop_speed: float = 25.0

func enter():
	owner.is_sprinting = true
	print("Player Run State")
	# play run animation if needed

func physics_process(delta: float) -> void:
	# Gravity
	if not owner.is_on_floor():
		owner.velocity.y -= owner.gravity * delta

	# Input
	var input_dir_2d: Vector2 = Input.get_vector("left", "right", "forward", "backward")
	var input_dir: Vector3 = Vector3(input_dir_2d.x, 0.0, input_dir_2d.y)
	var direction: Vector3 = (owner.global_transform.basis * input_dir).normalized()

	var run_speed: float = owner.movement_speed * sprint_multiplier

	if direction != Vector3.ZERO and Input.is_action_pressed("sprint"):
		# CONSTANT SPEED: run faster than walk
		owner.velocity.x = direction.x * run_speed
		owner.velocity.z = direction.z * run_speed
	else:
		# No input or sprint released → stop horizontal movement
		owner.velocity.x = 0.0
		owner.velocity.z = 0.0

	# Jump
	if Input.is_action_just_pressed("jump") and owner.is_on_floor():
		owner.velocity.y = owner.jump_impulse

	# Transitions
	if direction == Vector3.ZERO:
		state_machine.change_state("idle")
	elif not Input.is_action_pressed("sprint"):
		# Still moving but sprint released → walk
		state_machine.change_state("walk")

	owner.move_and_slide()
