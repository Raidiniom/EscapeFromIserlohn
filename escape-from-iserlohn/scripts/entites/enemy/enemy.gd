# enemy.gd
extends CharacterBody3D

@export var data: EnemyData

# Enemy Stats
var health: float
var speed: float
var armor: float
var attack_damage: float
var attack_speed: float
var attack_range: float
var attack_type: String
var is_dead : bool = false

# Rogue - Dash Ability
var is_dashing: bool = false
var can_dash: bool
var dash_speed_multiplier: float
var dash_cooldown: float
var dash_min_range: float
var dash_max_range: float

# Ranger - Blink Ability
var is_blinking: bool = false
var can_blink: bool
var blink_distance: float
var blink_cooldown: float

# Summoner - Summoning Ability
var is_summoning: bool = false
var can_summon: bool
var summon_count: int
var summon_cooldown: float
var summon_timer: float
var summon_range: float
var summon_scene: PackedScene

# Utilities
var gravity : float = 9.8
var player_target: Node3D = null
var can_attack := true
var target_offset: Vector3
var counts_for_round: bool
var team = TeamManager.Team.ENEMY

# Enemy Parts
@onready var navigation: NavigationAgent3D = $NavigationAgent3D
@onready var state_machine = $StateMachine
@onready var health_display = $Label3D

func _ready() -> void:
	if data != null:
		apply_data()
	else:
		print("No Enemy Data Assigned")
	
	health_display.text = str(floor(health))
	
	var radius = 2.0
	target_offset = Vector3(
		randf_range(-radius, radius),
		0,
		randf_range(-radius, radius)
	)
	

func apply_data():
	print("LOADED DATA:", data)
	
	health = data.health
	speed = data.speed
	armor = data.armor
	attack_damage = data.attack_damage
	attack_speed = data.attack_speed
	attack_range = data.attack_range
	attack_type = data.attack_type
	counts_for_round = data.counts_for_round
	
	# Dash Stats
	can_dash = data.can_dash
	dash_speed_multiplier = data.dash_speed_multiplier
	dash_cooldown = data.dash_cooldown
	dash_min_range = data.dash_min_range
	dash_max_range = data.dash_max_range
	
	# Blink Stats
	can_blink = data.can_blink
	blink_distance = data.blink_distance
	blink_cooldown = data.blink_cooldown
	
	# Summoning Stats
	can_summon = data.can_summon
	summon_count = data.summon_count
	summon_cooldown = data.summon_cooldown
	summon_timer = data.summon_timer
	summon_range = data.summon_range
	summon_scene = data.summon_scene
	

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	if can_summon:
		summon_timer -= delta
	

func move_to_target(delta):
	if player_target == null:
		return
	
	if is_dashing:
		return
	
	var direction = Vector3.ZERO
	
	direction += get_seek_force()
	direction += get_separation_force() * 1.5
	direction += get_offset_force()
	
	direction.y = 0
	
	if direction.length() < 0.01:
		return
	
	direction = direction.normalized()
	
	apply_movement(direction, delta)
	

func get_seek_force() -> Vector3:
	var target_pos = player_target.global_position
	return (target_pos - global_position).normalized()

func get_offset_force() -> Vector3:
	var target_pos = player_target.global_position + target_offset
	return (target_pos - global_position).normalized()

func apply_movement(direction: Vector3, delta: float):
	var distance = global_position.distance_to(player_target.global_position)
	
	# Stop at attack range
	if distance <= attack_range:
		velocity.x = 0
		velocity.z = 0
		return
	
	# Smooth slow down
	var slow_radius = attack_range + 1.5
	var move_speed = speed
	
	if distance < slow_radius:
		move_speed = speed * (distance / slow_radius)
	
	# Smooth rotation
	var target_basis = Basis().looking_at(direction, Vector3.UP)
	transform.basis = transform.basis.slerp(target_basis, 5 * delta)
	
	velocity.x = direction.x * move_speed
	velocity.z = direction.z * move_speed
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
	
	move_and_slide()

func get_separation_force() -> Vector3:
	var separation_radius = 2.0
	var force = Vector3.ZERO
	
	for other in get_tree().get_nodes_in_group("enemy"):
		if other == self:
			continue
		
		var diff = global_position - other.global_position
		var dist = diff.length()
		
		if dist > 0 and dist < separation_radius:
			force += diff.normalized() / dist
	
	return force

func take_damage(amount: float):
	var final_dmg = calculate_damage(amount, armor)
	health -= final_dmg
	
	health_display.text = str(floor(health))
	if health <= 0 and !is_dead:
		die()

func calculate_damage(amount: float, armor: float) -> float:
	var damage_reduction = armor / (armor + 100)
	var final_damage = amount * (1 - damage_reduction)
	
	# Ensure minimum damage of 1
	return max(1.0, final_damage)

func drop_seed():
	var player = get_tree().get_first_node_in_group("player")

	var luck := 0.0
	if player != null:
		luck = player.luck_stat

	var loot_table = [
		{"type": SeedTypes.SeedType.DAMAGE, "weight": 50},
		{"type": SeedTypes.SeedType.MOVEMENT, "weight": 20},
		{"type": SeedTypes.SeedType.ATTACK_SPEED, "weight": 15},
		{"type": SeedTypes.SeedType.HEALTH, "weight": 10},
		{"type": SeedTypes.SeedType.ARMOR, "weight": 4},
		{"type": SeedTypes.SeedType.LUCK, "weight": 1}
	]

	var total_weight := 0.0

	# Apply luck (boost rare items more)
	for item in loot_table:
		var is_rare: bool = item["weight"] <= 10

		if is_rare:
			item["weight"] += luck * 2.5  # luck favors rare drops more

		total_weight += item["weight"]

	var roll := randf() * total_weight
	var current := 0.0

	for item in loot_table:
		current += item["weight"]
		if roll <= current:
			print("[DEBUG] Dropped:", item["type"])
			GameDataManager.add_seed(item["type"])
			return
	

func die():
	is_dead = true
	
	if counts_for_round:
		GameManager.enemies_alive -= 1
		drop_seed()
		
		if GameManager.enemies_alive <= 0:
			GameManager.next_round()
	
	queue_free()
