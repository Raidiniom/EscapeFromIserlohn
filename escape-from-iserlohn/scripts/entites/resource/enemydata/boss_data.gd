# boss_data.gd
extends EnemyData
class_name BossData

@export_category("Boss Properties")
@export var phase_threshold: float = 0.5
@export var enrage_speed_multiplier: float = 1.4
@export var enrage_damage_multiplier: float = 1.5

@export_category("Boss Skills")
@export_subgroup("Charge - Melee Boss")
@export var can_charge: bool = false
@export var charge_speed_multiplier: float = 9.0
@export var charge_cooldown: float = 6.0

@export_subgroup("Harden - Heavy Boss")
@export var can_harden: bool = false
@export var harden_armor_bonus: float = 50.0
@export var harden_duration: float = 4.0
@export var harden_cooldown: float = 10.0

@export_subgroup("Rapid Fire - Range Boss")
@export var can_rapid_fire: bool = false
@export var rapid_fire_duration: float = 3.0
@export var rapid_fire_cooldown: float = 12.0

@export_subgroup("Mass Summon - Summoner Boss")
@export var can_mass_summon: bool = false
@export var mass_summon_count: int = 4
@export var mass_summon_cooldown: float = 15.0
