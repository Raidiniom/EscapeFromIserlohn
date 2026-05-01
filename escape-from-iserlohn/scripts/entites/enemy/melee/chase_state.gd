# chase_state.gd
extends State

func enter():
	print("Enemy Chase")

func physics_process(delta):
	var enemy = owner
	
	if enemy.player_target == null:
		return
	
	enemy.move_to_target(delta)
	
	var distance = enemy.global_transform.origin.distance_to(
		enemy.player_target.global_transform.origin
	)
	
	if distance <= enemy.attack_range:
		state_machine.change_state("attack")
	

func exit():
	pass
