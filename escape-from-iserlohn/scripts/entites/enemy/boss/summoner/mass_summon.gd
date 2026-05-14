# mass_summon_state.gd
extends State

var summon_timer: float = 0.0
var summoning: bool = false
const SUMMON_DELAY: float = 0.3  # delay between each spawn for dramatic effect
const NORMAL_ENEMY_POOL = ["melee", "heavy", "rogue", "range", "summoner"]

func get_enemy():
	return state_machine.get_parent()
	

func enter():
	var enemy = get_enemy()
	enemy.mass_summon_ready = false
	summoning = true
	enemy.velocity = Vector3.ZERO
	print(enemy.name + " — MASS SUMMON TRIGGERED, count: " + str(enemy.mass_summon_count))
	# Start the summon sequence
	summon_sequence(enemy)
	

func summon_sequence(enemy):
	var count = enemy.mass_summon_count
	for i in range(count):
		# Stagger each spawn
		await get_tree().create_timer(SUMMON_DELAY * i).timeout
		if not is_instance_valid(enemy):
			return
		spawn_enemy(enemy)
	
	# Done summoning, go back to chase
	if is_instance_valid(enemy):
		summoning = false
		state_machine.change_state("chase")
	

func spawn_enemy(enemy):
	# Pick a random type from the normal enemy pool
	var type = NORMAL_ENEMY_POOL[randi() % NORMAL_ENEMY_POOL.size()]
	var scene = GameManager.enemy_scenes.get(type)
	
	if scene == null:
		push_error("MassSummonState: Could not find scene for type: " + type)
		return
	
	var summoned = scene.instantiate()
	
	# Spawn in a ring around the boss
	var angle = randf() * TAU
	var radius = randf_range(2.0, enemy.summon_range if enemy.get("summon_range") else 5.0)
	var offset = Vector3(cos(angle) * radius, 0, sin(angle) * radius)
	
	get_tree().current_scene.add_child(summoned)
	summoned.global_position = enemy.global_position + offset
	summoned.player_target = enemy.player_target
	
	# Summoned enemies don't count toward round completion
	if summoned.get("counts_for_round") != null:
		summoned.counts_for_round = false
	
	GameManager.enemies_alive += 1
	print("Summoned: " + type)
	

func physics_process(delta):
	var enemy = get_enemy()
	# Stay frozen while summoning
	enemy.velocity.x = 0
	enemy.velocity.z = 0
	

func exit():
	var enemy = get_enemy()
	var timer = get_tree().create_timer(enemy.mass_summon_cooldown)
	timer.timeout.connect(func():
		if is_instance_valid(enemy):
			enemy.mass_summon_ready = true
	)
	
