# death_manager.gd
extends Node

var death_ui: Control
var player: CharacterBody3D

func show_death():
	get_tree().paused = true
	death_ui.show()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	

func respawn():
	get_tree().paused = false
	
	GameManager.reset_run()
	GameDataManager.reset_seeds()
	clear_world()
	
	death_ui.hide()
	
	player.respawn()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GameManager.start_round()

func exit_to_menu(scene_path: String):
	get_tree().paused = false
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	await get_tree().process_frame
	
	get_tree().change_scene_to_file(scene_path)

func clear_world():
	for e in get_tree().get_nodes_in_group("enemy"):
		if is_instance_valid(e):
			e.queue_free()
	
	for p in get_tree().get_nodes_in_group("plant"):
		if is_instance_valid(p):
			p.queue_free()
	
	print("[GAME] World cleared")
	
