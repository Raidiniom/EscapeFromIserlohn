extends Node

var seeds := {
	SeedTypes.SeedType.DAMAGE: 0,
	SeedTypes.SeedType.MOVEMENT: 0,
	SeedTypes.SeedType.ATTACK_SPEED: 0,
	SeedTypes.SeedType.HEALTH: 0,
	SeedTypes.SeedType.ARMOR: 0,
	SeedTypes.SeedType.LUCK: 0
}

var plant_data_map := {}

func _ready():
	plant_data_map = {
		SeedTypes.SeedType.DAMAGE: preload("res://scripts/entites/resource/plantdata/damage_plant.tres"),
		SeedTypes.SeedType.MOVEMENT: preload("res://scripts/entites/resource/plantdata/movement_plant.tres"),
		SeedTypes.SeedType.ATTACK_SPEED: preload("res://scripts/entites/resource/plantdata/speed_plant.tres"),
		SeedTypes.SeedType.HEALTH: preload("res://scripts/entites/resource/plantdata/health_plant.tres"),
		SeedTypes.SeedType.ARMOR: preload("res://scripts/entites/resource/plantdata/armor_plant.tres"),
		SeedTypes.SeedType.LUCK: preload("res://scripts/entites/resource/plantdata/luck_plant.tres")
	}

func add_seed(type: int, amount := 1):
	seeds[type] += amount

func consume_seed(type: int) -> bool:
	if seeds[type] > 0:
		seeds[type] -= 1
		return true
	return false
