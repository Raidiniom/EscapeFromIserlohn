# planting_state.gd
extends State

var timer := 0.0
@export var plant_duration := 1.5

var plant_model: PackedScene

func enter():
	timer = 0.0
	print("Player Started Planting")
	
	spawn_plant()

func spawn_plant():
	if not owner.can_plant():
		print("Not Plantable ground!")
		return
	
	if not GameDataManager.consume_seed(owner.selected_seed):
		print("No Seeds")
		return
	
	var data : PlantData = GameDataManager.plant_data_map.get(owner.selected_seed)
	
	if data == null:
		print("No PlanData for seed: ", owner.selected_seed)
		return
	
	if data.plant_model == null:
		print("No Assign Scene: ", owner.selected_seed)
		return
	
	var pos = owner.get_plant_position()
	
	var plant = data.plant_model.instantiate()
	plant.global_position = pos
	
	plant.data = data
	
	print("[DEBUG] Seed Being Planted")
	
	get_tree().current_scene.add_child(plant)
	
	print("[DEBUG] Spawned plant with data:", data)
	

func process(delta):
	timer += delta
	if timer >= plant_duration:
		state_machine.change_state("idle")

func exit():
	print("Done Planting")
