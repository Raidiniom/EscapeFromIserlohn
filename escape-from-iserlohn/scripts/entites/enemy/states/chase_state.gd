# chase_state.gd
extends State

func enter():
	owner.play_anim("Chase")

func physics_process(delta):
	var enemy = owner
	
	if enemy.player_target == null:
		state_machine.change_state("chase")
		return
	
	var distance = enemy.global_transform.origin.distance_to(
		enemy.player_target.global_transform.origin
	)
	
	# Normal Enemy
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
	
	# Boss Enemy
	if enemy.get("can_charge") and enemy.can_charge and enemy.charge_ready:
		if distance > 6.0 and distance < 15.0:
			state_machine.change_state("charge")
			return
	
	if enemy.get("can_harden") and enemy.can_harden and enemy.harden_ready:
		var dist = enemy.global_position.distance_to(
			enemy.player_target.global_position
		)
		if dist <= 14.0:
			state_machine.change_state("harden")
			return
		
	
	if enemy.get("can_rapid_fire") and enemy.can_rapid_fire and enemy.rapid_fire_ready:
		if distance <= enemy.attack_range:
			state_machine.change_state("rapidfire")
			return
	
	if enemy.get("can_mass_summon") and enemy.can_mass_summon and enemy.mass_summon_ready:
		state_machine.change_state("masssummon")
		return
	
	enemy.move_to_target(delta)
	
	if distance <= enemy.attack_range:
		if enemy.attack_type == "ranged":
			state_machine.change_state("rangeattack")
		else:
			state_machine.change_state("attack")
	

func exit():
	pass
