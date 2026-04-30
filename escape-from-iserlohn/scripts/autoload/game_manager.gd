extends Node

@export var enemy_scene: PackedScene
@export var spawn_points: Array[Node3D]

var current_round := 1
var enemies_alive := 0

func start_round():
	var count = current_round * 10  # scaling

	enemies_alive = count

	for i in range(count):
		spawn_enemy()

func spawn_enemy():
	if enemy_scene == null or spawn_points.is_empty():
		return
	
	var spawn = spawn_points.pick_random()
	var enemy = enemy_scene.instantiate()
	
	enemy.global_position = spawn.global_position
	
	get_tree().current_scene.add_child(enemy)

func next_round():
	current_round += 1
	
	await get_tree().create_timer(2.0).timeout
	start_round()
