extends State

func enter():
	print("Enemy Idle")

func physics_process(delta):
	if player.player_target != null:
		state_machine.change_state("chase")
