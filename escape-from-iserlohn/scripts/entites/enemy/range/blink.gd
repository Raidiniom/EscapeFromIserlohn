# blink.gd
extends State

func enter():
	var enemy = owner
	
	if enemy.player_target == null:
		state_machine.change_state("chase")
		return
	
	if not enemy.can_blink:
		state_machine.change_state("chase")
		return
	
	enemy.is_blinking = true
	enemy.can_blink = false
	
	blink(enemy)
	

func physics_process(delta):
	state_machine.change_state("rangeattack")

func blink(enemy):
	var player_pos = enemy.player_target.global_position
	
	var direction = (enemy.global_position - player_pos).normalized()
	var blink_dist = enemy.blink_distance
	
	var target_pos = enemy.global_position + direction * blink_dist
	
	enemy.global_position = target_pos
	

func exit():
	var enemy = owner
	
	enemy.is_blinking = false
	
	# cooldown reset (from EnemyData)
	get_tree().create_timer(enemy.blink_cooldown).timeout.connect(func():
		if is_instance_valid(enemy):
			enemy.can_blink = true
	)
