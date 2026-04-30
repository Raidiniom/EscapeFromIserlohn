extends State

func enter():
	print("Enemy Attack")
	attack_loop()

func attack_loop():
	while true:
		# If no target → stop
		if player.player_target == null:
			return
	
		var dist = player.global_position.distance_to(player.player_target.global_position)
	
		# If player escaped → go back to chase
		if dist > 2.0:
			state_machine.change_state("chase")
			return
	
		# Deal damage
		if player.player_target.has_method("take_damage"):
			player.player_target.take_damage(player.attack_damage)
	
		await get_tree().create_timer(1.0 / player.attack_speed).timeout
