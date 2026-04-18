# Attack.gd
extends State

func enter():
	# Trigger attack animation
	# Connect to animation_player's "animation_finished" signal to know when to exit
	print("Start Attack")

func exit():
	print("End Attack")
	# Disconnect from animation signal

func _on_animation_finished(anim_name: String):
	if anim_name == "attack":
		state_machine.change_state("idle")
