# rapid_fire_state.gd
extends State

var rapid_fire_timer: float = 0.0
var attack_timer: float = 0.0
const RAPID_FIRE_ATTACK_SPEED: float = 6.0  # shots per second during rapid fire

@export var projectile_scene: PackedScene  # assign same projectile as RangeAttack node

func get_enemy():
	return state_machine.get_parent()
	

func enter():
	var enemy = get_enemy()
	enemy.rapid_fire_ready = false
	rapid_fire_timer = enemy.rapid_fire_duration
	attack_timer = 0.0
	

func physics_process(delta):
	var enemy = get_enemy()
	
	if enemy.player_target == null:
		state_machine.change_state("chase")
		return
	
	# Face the player but don't move
	var direction = (enemy.player_target.global_position - enemy.global_position).normalized()
	direction.y = 0
	if direction.length() > 0.01:
		var target_basis = Basis().looking_at(direction, Vector3.UP)
		enemy.transform.basis = enemy.transform.basis.slerp(target_basis, 10 * delta).orthonormalized()
	
	enemy.velocity.x = 0
	enemy.velocity.z = 0
	
	# Shoot rapidly
	attack_timer -= delta
	if attack_timer <= 0:
		attack_timer = 1.0 / RAPID_FIRE_ATTACK_SPEED
		shoot(enemy)
	
	# End rapid fire
	rapid_fire_timer -= delta
	if rapid_fire_timer <= 0:
		state_machine.change_state("chase")
	

func shoot(enemy):
	if projectile_scene == null:
		push_error("RapidFireState: No projectile scene assigned")
		return
	if enemy.player_target == null or not enemy.is_inside_tree():
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
	
func exit():
	var enemy = get_enemy()
	var timer = get_tree().create_timer(enemy.rapid_fire_cooldown)
	timer.timeout.connect(func():
		if is_instance_valid(enemy):
			enemy.rapid_fire_ready = true
	)
	
