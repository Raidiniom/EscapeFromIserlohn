extends Node

var enemy_scenes = {
	"melee": preload("res://scenes/entities/enemy/melee_enemy.tscn"),
	"heavy": preload("res://scenes/entities/enemy/heavy_melee_enemy.tscn"),
	"rogue": preload("res://scenes/entities/enemy/rogue_enemy.tscn"),
	"range": preload("res://scenes/entities/enemy/ranger_enemy.tscn"),
	"summoner": preload("res://scenes/entities/enemy/summoner_enemy.tscn"),
	"melee_boss": preload("res://scenes/entities/enemy/melee_boss.tscn"),
	"heavymelee_boss": preload("res://scenes/entities/enemy/heavy_melee_boss.tscn"),
	"range_boss": preload("res://scenes/entities/enemy/range_boss.tscn"),
	"summoner_boss": preload("res://scenes/entities/enemy/summoner_boss.tscn"),
}

# Enemy type weights - higher number = higher chance to spawn
var enemy_weights = {
	"melee": 0,
	"heavy": 0,
	"rogue": 0,
	"range": 0,
	"summoner": 0
}

var boss_schedule = {
	5: ["summoner_boss"],
	10: ["heavymelee_boss"],
	15: ["range_boss"],
	25: ["summoner_boss"],
	30: ["melee_boss", "heavymelee_boss"],
	35: ["melee_boss", "range_boss"],
	40: ["melee_boss", "summoner_boss"],
	45: ["heavymelee_boss", "range_boss"],
	50: ["heavymelee_boss", "summoner_boss"],
	55: ["melee_boss", "heavymelee_boss", "range_boss"],
	60: ["melee_boss", "heavymelee_boss", "summoner_boss"],
	65: ["melee_boss", "heavymelee_boss", "range_boss", "range_boss"],
	100: ["melee_boss", "heavymelee_boss", "range_boss", "melee_boss", "heavymelee_boss", "range_boss", "summoner_boss", "summoner_boss"],
}

var spawn_points: Array[Node3D] = []

var current_round := 1
var enemies_alive := 0

var round_timeout_timer = 0.0
var round_timeout_limit = 60.0

#func _process(delta: float) -> void:
	#if enemies_alive > 0:
		#round_timeout_timer += delta
		#if round_timeout_timer >= round_timeout_limit:
			#print("[TIMEOUT] Forcing next round — ", enemies_alive, " enemies never died")
			#enemies_alive = 0
			#next_round()
	#else:
		#round_timeout_timer = 0.0

func start_round():
	await get_tree().process_frame
	
	spawn_points.clear()
	for node in get_tree().get_nodes_in_group("spawner"):
		if node is Node3D:
			spawn_points.append(node)
	
	 #Adjust weights based on round number
	update_weights_for_round()
	
	var count = get_enemy_count_for_round()
	
	display(current_round, count)
	
	if boss_schedule.has(current_round):
		for boss_type in boss_schedule[current_round]:
			spawn_boss(boss_type)
	
	for i in range(count):
		var type = pick_enemy_type()
		spawn_enemy(type)
	
	enemies_alive = count
	
	# Optional: Debug print of spawned enemy types this round
	print_round_summary()

func get_enemy_count_for_round() -> int:
	# Round 5 gets extra enemies to go with the boss
	var base = current_round * 5
	if boss_schedule.has(current_round):
		return base + 10
	
	return base
	

func update_weights_for_round():
	var r = current_round
	
	var range_bonus = 15 if r >= 5 else 0
	var summoner_bonus = 10 if r >= 5 else 0
	
	set_weights({
		"melee": clamp(80 - r * 5, 20, 80),
		"rogue": clamp(r * 3, 0, 30),
		"range": clamp((r - 2) * 3 + range_bonus, 0, 45),
		"heavy": clamp((r - 4) * 3, 0, 25),
		"summoner": clamp((r - 5) * 2 + summoner_bonus, 0, 35)
	})
	

func set_weights(new_weights: Dictionary):
	for type in enemy_weights.keys():
		enemy_weights[type] = new_weights.get(type, 0)
	

func spawn_enemy(type):
	var scene = enemy_scenes[type]
	var spawn = spawn_points.pick_random()
	var enemy = scene.instantiate()
	
	get_tree().current_scene.add_child.call_deferred(enemy)
	await get_tree().process_frame
	
	enemy.global_position = spawn.global_position
	var player = get_tree().get_nodes_in_group("player")[0]
	enemy.player_target = player
	

func spawn_boss(type: String):
	var scene = enemy_scenes[type]
	var spawn = spawn_points[0]
	var boss = scene.instantiate()
	
	get_tree().current_scene.add_child.call_deferred(boss)
	await get_tree().process_frame
	
	boss.global_position = spawn.global_position
	var player = get_tree().get_nodes_in_group("player")[0]
	boss.player_target = player
	
	boss.counts_for_round = false
	

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
	print("!!!=== Round #", round_num, " ===!!!")
	print("Enemy Count: ", enemy_count)
	

func print_round_summary():
	print("--- Round Summary ---")
	var total = get_total_weight()
	if total == 0:
		print("No enemies this round.")
		return
	for type in enemy_weights:
		var weight = enemy_weights[type]
		if weight > 0:
			var percentage = (float(weight) / total) * 100
			print(type.capitalize() + ": " + str(percentage).pad_decimals(1) + "%")
	print("--------------------")
	

func get_total_weight() -> int:
	var total = 0
	for weight in enemy_weights.values():
		total += weight
	return total

func reset_run():
	current_round = 1
	enemies_alive = 0
	
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.queue_free()
	
	spawn_points.clear()
	
