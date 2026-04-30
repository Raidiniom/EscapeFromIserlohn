extends State

@export var run_speed: float = 10.0

func enter():
	# Play animation here
	print("Plyaer Run State")

func physics_process(delta):
	# Apply gravity
	if not owner.is_on_floor():
		owner.velocity.y -= owner.gravity * delta

	# Get movement input
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (owner.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		owner.velocity.x = direction.x * run_speed
		owner.velocity.z = direction.z * run_speed
	else:
		owner.velocity.x = move_toward(owner.velocity.x, 0, run_speed)
		owner.velocity.z = move_toward(owner.velocity.z, 0, run_speed)

	# Transition logic
	if Input.is_action_just_pressed("plant"):
		state_machine.change_state("planting")
	elif direction == Vector3.ZERO:
		state_machine.change_state("idle")
	# For Run.gd, you would add a transition back to Walk or Idle if sprint is released.

	owner.move_and_slide()
