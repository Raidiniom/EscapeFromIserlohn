extends Node

var enemy_scenes = {
	"melee": preload("res://scenes/entities/enemy/melee_enemy.tscn"),
	"heavy": preload("res://scenes/entities/enemy/heavy_melee_enemy.tscn"),
	"rogue": preload("res://scenes/entities/enemy/rogue_enemy.tscn"),
	"range": preload("res://scenes/entities/enemy/ranger_enemy.tscn"),
	"summoner": preload("res://scenes/entities/enemy/summoner_enemy.tscn")
}

# Enemy type weights - higher number = higher chance to spawn
var enemy_weights = {
	"melee": 0,
	"heavy": 0,
	"rogue": 100,
	"range": 0,
	"summoner": 0
}

var spawn_points: Array[Node3D] = []

var current_round := 1
var enemies_alive := 0

func start_round():
	await get_tree().process_frame
	
	spawn_points.clear()
	
	for node in get_tree().get_nodes_in_group("spawner"):
		if node is Node3D:
			spawn_points.append(node)
	
	# Adjust weights based on round number
	update_weights_for_round()
	
	var count = current_round * 5
	enemies_alive = count
	
	display(current_round, count)
	
	for i in range(count):
		var type = pick_enemy_type()
		spawn_enemy(type)
	
	# Optional: Debug print of spawned enemy types this round
	print_round_summary()

func update_weights_for_round():
	# Make later rounds more challenging by adjusting weights
	match current_round:
		1, 2:
			enemy_weights["melee"] = 0
			enemy_weights["heavy"] = 0
			enemy_weights["rogue"] = 0
			enemy_weights["range"] = 0
			enemy_weights["summoner"] = 100
		
		3, 4:
			enemy_weights["melee"] = 0
			enemy_weights["heavy"] = 0
			enemy_weights["rogue"] = 0
			enemy_weights["range"] = 0
			enemy_weights["summoner"] = 100
		
		5, 6:
			enemy_weights["melee"] = 0
			enemy_weights["heavy"] = 0
			enemy_weights["rogue"] = 0
			enemy_weights["range"] = 0
			enemy_weights["summoner"] = 100
		
		_:
			# Rounds 7+ become increasingly difficult
			enemy_weights["melee"] = 0
			enemy_weights["heavy"] = 0
			enemy_weights["rogue"] = 0
			enemy_weights["range"] = 0
			enemy_weights["summoner"] = 100

func spawn_enemy(type):
	var scene = enemy_scenes[type]
	var spawn = spawn_points.pick_random()
	var enemy = scene.instantiate()
	
	get_tree().current_scene.add_child(enemy)
	
	enemy.global_position = spawn.global_position
	
	var player = get_tree().get_nodes_in_group("player")[0]
	enemy.player_target = player

func pick_enemy_type():
	# Calculate total weight
	var total_weight = 0
	for weight in enemy_weights.values():
		total_weight += weight
	
	# Roll for enemy type based on weights
	var roll = randf() * total_weight
	var cumulative = 0
	
	for type in enemy_weights:
		cumulative += enemy_weights[type]
		if roll < cumulative:
			return type
	
	# Fallback (should never reach here)
	return "melee"

func next_round():
	current_round += 1
	
	await get_tree().create_timer(2.0).timeout
	start_round()

func display(round_num, enemy_count):
	print("!!!=== Round #",round_num," ===!!!")
	print("Enemy Count: ", enemy_count)

func print_round_summary():
	print("--- Round Summary ---")
	for type in enemy_weights:
		var weight = enemy_weights[type]
		var percentage = (float(weight) / get_total_weight()) * 100
		print(type.capitalize() + ": " + str(percentage).pad_decimals(1) + "% chance")
	print("--------------------")

func get_total_weight() -> int:
	var total = 0
	for weight in enemy_weights.values():
		total += weight
	return total

# Optional: Add manual weight adjustment function
func set_enemy_weight(type: String, weight: int):
	if enemy_weights.has(type):
		enemy_weights[type] = weight

# Optional: Add ranged enemy spawn (was missing from your original picker)
func has_ranged_enemy() -> bool:
	return "range" in enemy_scenes and enemy_weights["range"] > 0
