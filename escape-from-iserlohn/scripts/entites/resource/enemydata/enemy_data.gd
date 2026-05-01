extends Resource
class_name EnemyData

@export_category("Base Enemy Stat")
@export var health: float
@export var speed: float
@export var armor: float
@export var attack_damage: float
@export var attack_speed: float
@export var attack_range: float

@export_category("Enemy Abilities")
# Rogue - Dash Ability
@export var can_dash: bool
@export var dash_speed_multiplier: float
@export var dash_cooldown: float
@export var dash_min_range: float
@export var dash_max_range: float

# Range = Reposition Ability

# Summoner = Summoning Ability
