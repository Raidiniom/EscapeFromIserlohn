extends Control

@onready var player = get_parent().get_parent()

@onready var health_bar = $TopLeft/HealthBar
@onready var exp_bar = $TopLeft/ProgressBar
@onready var stats_label = $TopLeft/StatsLabel
@onready var inventory_label = $BottomLeft/Inventory

func _ready():
	player.connect("stats_changed", update_hud)
	update_hud()

func _process(delta):
	if player == null:
		return
	
	update_hud()

func update_hud():
	# Health
	health_bar.max_value = player.max_health
	health_bar.value = player.health
	
	exp_bar.max_value = player.exp_to_next
	exp_bar.value = player.exp

	# Stats
	stats_label.text = "HP: %d/%d | LVL: %d | DMG: %d | ARM: %.1f | ATK: %.1f | SPD: %.1f | LUCK: %.1f" % [
		player.health,
		player.max_health,
		player.level,
		player.base_damage,
		player.armor,
		player.attack_speed,
		player.movement_speed,
		player.luck_stat
	]

	# Inventory (your seed system)
	inventory_label.text = "[1] Damage - %d\n[2] Speed - %d\n[3] Attac Speed - %d\n[4] Health - %d\n[5] Armor - %d\n[6] Luck - %d\nSelected: %s" % [
		GameDataManager.seeds[SeedTypes.SeedType.DAMAGE],
		GameDataManager.seeds[SeedTypes.SeedType.MOVEMENT],
		GameDataManager.seeds[SeedTypes.SeedType.ATTACK_SPEED],
		GameDataManager.seeds[SeedTypes.SeedType.HEALTH],
		GameDataManager.seeds[SeedTypes.SeedType.ARMOR],
		GameDataManager.seeds[SeedTypes.SeedType.LUCK],
		get_selected_name(player.selected_seed)
	]

func get_selected_name(seed):
	match seed:
		SeedTypes.SeedType.DAMAGE: return "DMG"
		SeedTypes.SeedType.MOVEMENT: return "MOV"
		SeedTypes.SeedType.ATTACK_SPEED: return "ATK"
		SeedTypes.SeedType.HEALTH: return "HP"
		SeedTypes.SeedType.ARMOR: return "ARM"
		SeedTypes.SeedType.LUCK: return "LUCK"
	return "?"
