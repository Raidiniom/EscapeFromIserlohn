extends State

func enter():
	print("Enemy Chase")

func physics_process(delta):
	if player.player_target == null:
		return
	
	var target_pos = player.player_target.global_position
	player.navigation.target_position = target_pos
	
	var next_pos = player.navigation.get_next_path_position()
	var velocity_dir = (next_pos - player.global_position)
	
	velocity_dir.y = 0
	velocity_dir = velocity_dir.normalized()
	
	player.velocity = velocity_dir * player.speed
	player.move_and_slide()
	
	if velocity_dir.length() > 0.01:
		player.look_at(player.global_position + velocity_dir, Vector3.UP)
	
	var dist = player.global_position.distance_to(target_pos)
	
	if dist < 2.0:
		state_machine.change_state("attack")
		return
	
	print("Target:", target_pos)
	print("Next path:", player.navigation.get_next_path_position())
	print("Enemy forward:", -player.global_transform.basis.z)
	
