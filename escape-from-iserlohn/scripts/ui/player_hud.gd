# player_hud.gd
extends Control

@onready var player = get_parent().get_parent()

@onready var health_bar    = $TopLeft/HealthBar
@onready var exp_bar       = $TopLeft/ProgressBar
@onready var stats_label   = $TopLeft/StatsLabel

# seed buttons — order matches SeedTypes.SeedType enum (0–5)
@onready var seed_buttons: Array = [
	$SeedBar/SeedBtn0,
	$SeedBar/SeedBtn1,
	$SeedBar/SeedBtn2,
	$SeedBar/SeedBtn3,
	$SeedBar/SeedBtn4,
	$SeedBar/SeedBtn5,
]

@onready var joystick = $MoveJoystick
@onready var jumpbtn = $JumpButton
@onready var sprintbt  = $SprintButton
@onready var plantbtn = $PlantButton

func _ready() -> void:
	var health_fill = StyleBoxFlat.new()
	health_fill.bg_color = Color(0.85, 0.15, 0.15)  # red
	$TopLeft/HealthBar.add_theme_stylebox_override("fill", health_fill)
	
	var exp_fill = StyleBoxFlat.new()
	exp_fill.bg_color = Color(0.2, 0.6, 1.0)  # blue
	$TopLeft/ProgressBar.add_theme_stylebox_override("fill", exp_fill)
	
	player.connect("stats_changed", update_hud)
	
	InputManager.scheme_changed.connect(_on_scheme_changed)
	_on_scheme_changed(InputManager.current_scheme)
	
	for i in seed_buttons.size():
		var idx := i
		seed_buttons[i].pressed.connect(func():
			player.selected_seed = idx
			player.update_stats_display()
			_highlight_seed(idx)
		)
	update_hud()

func _on_scheme_changed(scheme) -> void:
	var is_mobile = scheme == InputManager.ControlScheme.MOBILE
	joystick.visible = is_mobile
	jumpbtn.visible = is_mobile
	sprintbt.visible = is_mobile
	plantbtn.visible = is_mobile
	

func _process(_delta: float) -> void:
	if player == null:
		return
	update_hud()

func update_hud() -> void:
	health_bar.max_value = player.max_health
	health_bar.value     = player.health
	exp_bar.max_value    = player.exp_to_next
	exp_bar.value        = player.exp

	stats_label.text = "HP %d/%d  LVL %d  DMG %d  ARM %.1f  ATK %.1f  SPD %.1f" % [
		player.health, player.max_health, player.level,
		player.base_damage, player.armor, player.attack_speed, player.movement_speed,
	]

	_highlight_seed(player.selected_seed)

	# update seed button text to show counts
	var types = [
		SeedTypes.SeedType.DAMAGE, SeedTypes.SeedType.MOVEMENT,
		SeedTypes.SeedType.ATTACK_SPEED, SeedTypes.SeedType.HEALTH,
		SeedTypes.SeedType.ARMOR, SeedTypes.SeedType.LUCK,
	]
	var names = ["DMG","MOV","ATK","HP","ARM","LUCK"]
	for i in seed_buttons.size():
		var count = GameDataManager.seeds[types[i]]
		seed_buttons[i].text = "%s\n%d" % [names[i], count]

func _highlight_seed(idx: int) -> void:
	for i in seed_buttons.size():
		seed_buttons[i].flat = (i != idx)

func get_selected_name(seed) -> String:
	match seed:
		SeedTypes.SeedType.DAMAGE:       return "DMG"
		SeedTypes.SeedType.MOVEMENT:     return "MOV"
		SeedTypes.SeedType.ATTACK_SPEED: return "ATK"
		SeedTypes.SeedType.HEALTH:       return "HP"
		SeedTypes.SeedType.ARMOR:        return "ARM"
		SeedTypes.SeedType.LUCK:         return "LUCK"
	return "?"
