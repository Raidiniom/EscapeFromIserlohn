extends State

var timer := 0.0
@export var plant_duration := 1.5

@export var plant_model = preload("res://scenes/entities/plant/plant.tscn")

func enter():
	timer = 0.0
	print("Start Planting")
	
	spawn_plant()

func spawn_plant():
	if not player.can_plant():
		print("Not Plantable ground!")
		return
	
	var pos = player.get_plant_position()
	
	var plant = plant_model.instantiate()
	plant.global_position = pos
	
	get_tree().current_scene.add_child(plant)

func process(delta):
	timer += delta
	if timer >= plant_duration:
		state_machine.change_state("idle")

func exit():
	print("Done Planting")
