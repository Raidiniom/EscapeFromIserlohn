# boss.gd
extends Enemy  # pulls in ALL of enemy.gd's logic
class_name Boss

@export var boss_data: BossData

var max_health: float
var current_phase: int = 1
var is_enraged: bool = false

# Charge - Melee Boss
var can_charge: bool = false
var charge_speed_multiplier: float = 3.0
var charge_cooldown: float = 6.0
var charge_ready: bool = true

# Harden - Heavy Boss
var can_harden: bool = false
var harden_cooldown: float = 10.0
var harden_ready: bool = true
var harden_armor_bonus: float = 50.0
var harden_duration: float = 4.0

# Rapid Fire - Range Boss
var can_rapid_fire: bool = false
var rapid_fire_cooldown: float = 12.0
var rapid_fire_ready: bool = true
var rapid_fire_duration: float = 3.0

# Mass Summon — Summoner Boss
var can_mass_summon: bool = false
var mass_summon_cooldown: float = 15.0
var mass_summon_ready: bool = true
var mass_summon_count: int = 4

var phase_threshold: float
var can_phase_transition: bool

signal phase_changed(new_phase: int)
signal boss_enraged

func _ready() -> void:
	super._ready()  # runs apply_data(), health_display, target_offset
	if boss_data != null:
		apply_boss_data()
	else:
		push_error(name + ": No BossData assigned")
	max_health = health

func apply_boss_data():
	# Charge
	can_charge = boss_data.can_charge
	charge_speed_multiplier = boss_data.charge_speed_multiplier
	charge_cooldown = boss_data.charge_cooldown
	# Harden
	can_harden = boss_data.can_harden
	harden_cooldown = boss_data.harden_cooldown
	harden_armor_bonus = boss_data.harden_armor_bonus
	harden_duration = boss_data.harden_duration
	# Rapid Fire
	can_rapid_fire = boss_data.can_rapid_fire
	rapid_fire_cooldown = boss_data.rapid_fire_cooldown
	rapid_fire_duration = boss_data.rapid_fire_duration
	# Mass Summon
	can_mass_summon = boss_data.can_mass_summon
	mass_summon_cooldown = boss_data.mass_summon_cooldown
	mass_summon_count = boss_data.mass_summon_count
	 # Boss core
	phase_threshold = boss_data.phase_threshold
	

func take_damage(amount: float) -> void:
	super.take_damage(amount)  # existing armor calc, die(), drop_seed() all intact
	check_phase_transition()

func check_phase_transition() -> void:
	if boss_data == null or max_health <= 0:
		return
	
	if current_phase == 1 and health <= max_health * phase_threshold:
		current_phase = 2
		phase_changed.emit(current_phase)
		state_machine.change_state("phasetransition")

func trigger_enrage() -> void:
	if is_enraged:
		return
	is_enraged = true
	speed *= boss_data.enrage_speed_multiplier
	attack_damage *= boss_data.enrage_damage_multiplier
	boss_enraged.emit()
