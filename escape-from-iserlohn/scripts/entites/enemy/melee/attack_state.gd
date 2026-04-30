extends State

var attacking := true

func enter():
	print("Enemy Attack")
	attacking = true
	attack_loop()

func attack_loop():
	while attacking:
		# If no target → stop
		if owner.player_target == null:
			return
	
		var dist = owner.global_position.distance_to(owner.player_target.global_position)
	
		# If player escaped → go back to chase
		if dist > owner.attack_range:
			state_machine.change_state("chase")
			return
	
		# Deal damage
		if owner.player_target.has_method("take_damage"):
			owner.player_target.take_damage(owner.attack_damage)
	
		await get_tree().create_timer(1.0 / owner.attack_speed).timeout

func exit():
	attacking = false
