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
	
	if enemy.can_blink:
		if distance < enemy.attack_range * 0.6:
			state_machine.change_state("blink")
			return
	
	if enemy.can_summon and enemy.summon_timer <= 0 and !enemy.is_summoning:
		state_machine.change_state("summoning")
		return
	
	enemy.move_to_target(delta)
	
	if distance <= enemy.attack_range:
		if enemy.attack_type == "ranged":
			state_machine.change_state("rangeattack")
		else:
			state_machine.change_state("attack")
	

func exit():
	pass
