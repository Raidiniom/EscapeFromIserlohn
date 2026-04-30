extends State

func enter():
	print("Enemy Chase")

func physics_process(delta):
	if player.player_target == null:
		state_machine.change_state("idle")
		return

	# Move toward player
	var target_pos = player.player_target.global_position
	player.navigation.target_position = target_pos
	
	var next_pos = player.navigation.get_next_path_position()
	var direction = (next_pos - player.global_position).normalized()
	
	player.velocity = direction * player.speed
	player.move_and_slide()

	# If close enough → attack
	if player.global_position.distance_to(target_pos) < 2.0:
		state_machine.change_state("attack")
