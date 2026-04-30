extends Node

@onready var enemy_melee = preload("res://scenes/entities/enemy/enemy.tscn")
var spawn_points: Array[Node3D] = []

var current_round := 1
var enemies_alive := 0

func start_round():
	await get_tree().process_frame
	
	spawn_points.clear()
	
	for node in get_tree().get_nodes_in_group("spawner"):
		if node is Node3D:
			spawn_points.append(node)
	
	var count = current_round * 5
	enemies_alive = count
	
	print("Enemy Count: ", enemies_alive)
	
	for i in range(count):
		spawn_enemy()
		print("Enemy #", i + 1)

func spawn_enemy():
	if enemy_melee == null or spawn_points.is_empty():
		print("Enemy Scene NULL" if enemy_melee else "No Spawn Points")
		return
	
	var spawn = spawn_points.pick_random()
	var enemy = enemy_melee.instantiate()
	
	get_tree().current_scene.add_child(enemy)
	
	enemy.global_position = spawn.global_position
	

func next_round():
	current_round += 1
	
	await get_tree().create_timer(2.0).timeout
	start_round()
