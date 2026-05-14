# harden_state.gd
extends State

var harden_timer: float = 0.0
var affected_enemies: Array = []

func get_enemy():
	return state_machine.get_parent()
	

func enter():
	var enemy = get_enemy()
	enemy.harden_ready = false
	harden_timer = enemy.harden_duration
	
	# Boost self
	enemy.armor += enemy.harden_armor_bonus
	
	# Boost nearby enemies
	affected_enemies.clear()
	for other in get_tree().get_nodes_in_group("enemy"):
		if other == enemy:
			continue
		
		if not other is Enemy:
			continue
		
		var dist = other.global_position.distance_to(enemy.global_position)
		if dist <= 8.0:
			other.armor += enemy.harden_armor_bonus
			affected_enemies.append(other)
	
	print(enemy.name + " HARDENED — buffed " + str(affected_enemies.size()) + " nearby enemies")
	

func physics_process(delta):
	var enemy = get_enemy()
	
	# Stay in place while hardening
	enemy.velocity.x = 0
	enemy.velocity.z = 0
	
	harden_timer -= delta
	state_machine.change_state("chase")
	

func exit():
	var enemy = get_enemy()
	
	# Revert self armor
	enemy.armor -= enemy.harden_armor_bonus
	
	# Revert nearby enemies armor
	for other in affected_enemies:
		if is_instance_valid(other) and other is Enemy:
			other.armor -= enemy.harden_armor_bonus
	affected_enemies.clear()
	
	# Start cooldown
	var timer = get_tree().create_timer(enemy.harden_cooldown)
	timer.timeout.connect(func():
		if is_instance_valid(enemy):
			enemy.harden_ready = true
	)
	
