# phase_transition_state.gd
extends State

var duration: float = 2.0
var timer: float = 0.0

func enter():
	timer = duration
	var enemy = owner
	# Stop all movement
	enemy.velocity = Vector3.ZERO
	# Trigger enrage if HP is low enough
	if enemy.health <= enemy.max_health * 0.2:
		enemy.trigger_enrage()
	print(enemy.name + " entering phase 2")

func physics_process(delta):
	var enemy = owner
	# Stay frozen during transition
	enemy.velocity.x = 0
	enemy.velocity.z = 0
	
	timer -= delta
	if timer <= 0:
		state_machine.change_state("chase")

func exit():
	pass
