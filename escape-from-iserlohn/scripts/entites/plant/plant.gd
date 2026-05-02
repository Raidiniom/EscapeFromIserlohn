# plant.gd
extends Node3D

@export var data: PlantData

# Plant Data
var seed_type: int
var growth_time: float
var timer: float = 0.0
var is_grown: bool

func _ready() -> void:
	if data != null:
		apply_data()
	else:
		print("No Enemy Data Assigned")
	

func _process(delta: float) -> void:
	if is_grown:
		return
	
	timer += delta
	
	if timer >= growth_time:
		grow()
	

func apply_data():
	print("LOADED DATA:", data)
	
	seed_type = data.seed_type
	growth_time = data.growth_time
	

func grow():
	is_grown = true
	apply_effect()
	

func apply_effect():
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	match seed_type:
		SeedTypes.SeedType.DAMAGE:
			player.base_damage += data.stat_value
		SeedTypes.SeedType.MOVEMENT:
			player.movement_speed += data.stat_value
		SeedTypes.SeedType.ATTACK_SPEED:
			player.attack_speed += data.stat_value
		SeedTypes.SeedType.HEALTH:
			player.health += data.stat_value
		SeedTypes.SeedType.ARMOR:
			player.armor += data.stat_value
		SeedTypes.SeedType.LUCK:
			player.luck_stat += data.stat_value
	
