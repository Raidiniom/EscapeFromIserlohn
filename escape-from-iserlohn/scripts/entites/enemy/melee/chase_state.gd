extends State

func enter():
	print("Enemy Chase")

func physics_process(delta):
	if owner.player_target == null:
		return
	
	var dist = owner.global_position.distance_to(owner.player_target.global_position)
	
	if dist <= owner.attack_range:
		state_machine.change_state("attack")
	
