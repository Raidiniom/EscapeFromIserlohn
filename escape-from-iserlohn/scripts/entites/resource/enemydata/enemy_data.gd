extends Resource
class_name EnemyData

@export_category("Base Enemy Stat")
@export var health: float
@export var speed: float
@export var armor: float
@export var attack_damage: float
@export var attack_speed: float
@export var attack_range: float

@export_subgroup("Attack Type")
@export var attack_type: String

@export_subgroup("Counts for Round")
@export var counts_for_round: bool = true

@export_category("Enemy Abilities")
@export_subgroup("Rogue - Dash Ability")
@export var can_dash: bool
@export var dash_speed_multiplier: float
@export var dash_cooldown: float
@export var dash_min_range: float
@export var dash_max_range: float

@export_subgroup("Ranger - Blink Ability")
@export var can_blink: bool
@export var blink_distance: float
@export var blink_cooldown: float

@export_subgroup("Summoner - Summoning Ability")
@export var can_summon: bool
@export var summon_count: int
@export var summon_cooldown: float
@export var summon_timer: float
@export var summon_range: float
@export var summon_scene: PackedScene
