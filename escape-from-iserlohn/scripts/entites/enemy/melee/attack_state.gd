extends State

func enter():
	print("Enemy Attack")

func physics_process(delta):
	if player.player_target == null:
		state_machine.change_state("idle")
		return

	var dist = player.global_position.distance_to(player.player_target.global_position)

	# If player moved away → chase again
	if dist > 2.5:
		state_machine.change_state("chase")
		return

	# Attack with cooldown
	if player.can_attack:
		player.can_attack = false
		perform_attack()

		await get_tree().create_timer(1.0 / player.attack_speed).timeout
		player.can_attack = true

func perform_attack():
	if player.player_target.has_method("take_damage"):
		player.player_target.take_damage(player.attack_damage)
