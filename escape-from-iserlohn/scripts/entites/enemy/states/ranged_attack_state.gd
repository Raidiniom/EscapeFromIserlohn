# ranged_attack_state.gd
extends State

var attack_timer := 0.0
@export var projectile_scene: PackedScene

func enter():
	attack_timer = 0
	

func physics_process(delta):
	var enemy = owner
	
	if enemy.player_target == null:
		state_machine.change_state("chase")
		return
	
	var distance = enemy.global_position.distance_to(enemy.player_target.global_position)
	
	if enemy.can_blink and distance < enemy.attack_range * 0.6:
		state_machine.change_state("blink")
		return
	
	if distance > enemy.attack_range:
		state_machine.change_state("chase")
		return
	
	enemy.velocity.x = 0
	enemy.velocity.z = 0
	
	attack_timer -= delta
	
	if attack_timer <= 0:
		attack_timer = 1.0 / max(enemy.attack_speed, 0.1)
		shoot(enemy)
	

func shoot(enemy):
	if projectile_scene == null:
		print("No Projectile Scene Assigned")
		return
	
	if enemy.player_target == null:
		return
	
	if !enemy.is_inside_tree():
		return
	
	var projectile = projectile_scene.instantiate()
	
	var direction = (enemy.player_target.global_position - enemy.global_position).normalized()
	
	var spawn_pos = enemy.global_position + direction * 1.5
	
	projectile.global_position = spawn_pos
	projectile.direction = direction
	projectile.speed = 20.0
	projectile.damage = enemy.attack_damage
	projectile.lifetime = 2.0
	projectile.source = enemy.team
	
	get_tree().current_scene.add_child(projectile)
	
