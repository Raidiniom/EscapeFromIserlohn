# chase_state.gd
extends State

func enter():
	pass

func physics_process(delta):
	var enemy = owner
	
	if enemy.player_target == null:
		state_machine.change_state("chase")
		return
	
	var distance = enemy.global_transform.origin.distance_to(
		enemy.player_target.global_transform.origin
	)
	
	if enemy.can_dash:
		if distance > enemy.dash_min_range and distance < enemy.dash_max_range:
			state_machine.change_state("dash")
			return
	
	enemy.move_to_target(delta)
	
	if distance <= enemy.attack_range:
		state_machine.change_state("attack")
	

func exit():
	pass
