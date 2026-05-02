# run.gd
extends State

@export var run_speed: float = 10.0

func enter():
	# Play animation here
	print("Plyaer Run State")

func physics_process(delta):
	if not owner.is_on_floor():
		owner.velocity.y -= owner.gravity * delta

	var input_dir = Input.get_vector("left", "right", "forward", "backward")
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
	elif owner.movement_speed <= 12:
		state_machine.change_state("walk")

	owner.move_and_slide()
