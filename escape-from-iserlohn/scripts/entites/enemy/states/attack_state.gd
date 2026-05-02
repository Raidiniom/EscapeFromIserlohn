# attack_state.gd
extends State

var attack_timer : float = 0.0

func enter():
	#print("Enemy Attack")
	attack_timer = 0
	

func physics_process(delta):
	var enemy = owner
	
	if enemy.player_target == null:
		state_machine.change_state("chase")
		return
	
	var distance = enemy.global_transform.origin.distance_to(
		enemy.player_target.global_transform.origin
	)
	
	# If player leaves range → go back to chase
	if distance > enemy.attack_range + 0.5:
		state_machine.change_state("chase")
		return
	
	# Stop movement
	enemy.velocity.x = 0
	enemy.velocity.z = 0
	
	attack_timer -= delta
	
	if attack_timer <= 0:
		attack_timer = 1.0 / max(enemy.attack_speed, 0.1)
		attack(enemy)

func attack(enemy):
	if enemy.player_target.has_method("take_damage"):
		enemy.player_target.take_damage(enemy.attack_damage)
	

func exit():
	pass
	
