extends State

var timer := 0.0
@export var plant_duration := 1.5

func enter():
	print("Start Planting")
	timer = 0.0

func process(delta):
	timer += delta
	if timer >= plant_duration:
		state_machine.change_state("idle")

func exit():
	print("End Planting")
