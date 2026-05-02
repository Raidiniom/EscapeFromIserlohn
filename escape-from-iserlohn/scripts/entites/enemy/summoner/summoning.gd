# summoning.gd
extends State

var finished := false

func enter():
	var enemy = owner
	
	if not enemy.can_summon:
		state_machine.change_state("chase")
		return
	
	enemy.is_summoning = true
	finished = false
	
	enemy.velocity = Vector3.ZERO
	
	await get_tree().create_timer(1.2).timeout
	
	summonning(enemy)
	
	enemy.summon_timer = enemy.summon_cooldown
	

func physics_process(delta):
	if finished:
		state_machine.change_state("chase")
	

func summonning(enemy):
	if enemy.summon_scene == null:
		print("No summon scene assigned!")
		finished = true
		return
	
	var scene = enemy.summon_scene
	
	for i in range(enemy.summon_count):
		var summon_instance = scene.instantiate()
		
		# Random spawn around summoner
		var offset = Vector3(
			randf_range(-enemy.summon_range, enemy.summon_range),
			0,
			randf_range(-enemy.summon_range, enemy.summon_range)
		)
		
		summon_instance.global_position = enemy.global_position + offset
		summon_instance.player_target = enemy.player_target
		
		# Set same player target
		summon_instance.player_target = enemy.player_target
		
		get_tree().current_scene.add_child(summon_instance)
	
	finished = true
	

func exit():
	owner.is_summoning = false
