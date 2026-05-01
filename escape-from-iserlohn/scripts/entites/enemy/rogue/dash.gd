# dash.gd
extends State

var direction := Vector3.ZERO
var dash_timer := 0.0
var stop_distance := 0.0
var stop_buffer := 0.0

func enter():
	var enemy = owner
	dash_timer = 1.0
	
	enemy.is_dashing = true
	enemy.can_dash = false
	
	# compute direction toward player (flat)
	if enemy.player_target == null:
		return
	
	direction = enemy.global_position.direction_to(enemy.player_target.global_position)
	direction.y = 0
	direction = direction.normalized()
	
	# stop at attack range (safe engage distance)
	stop_distance = enemy.attack_range
	


func physics_process(delta):
	dash(delta)
	

func dash(delta):
	var enemy = owner
	
	dash_timer -= delta
	
	if dash_timer <= 0:
		state_machine.change_state("chase")
		return
	
	if enemy.player_target == null:
		state_machine.change_state("chase")
		return
	
	var distance = enemy.global_position.distance_to(enemy.player_target.global_position)
	
	if distance <= stop_distance + stop_buffer:
		state_machine.change_state("attack")
		return
	
	# safety: if something breaks direction, recompute
	if direction == Vector3.ZERO:
		direction = enemy.global_position.direction_to(enemy.player_target.global_position)
		direction.y = 0
	
	enemy.velocity.x = direction.x * enemy.speed * enemy.dash_speed_multiplier
	enemy.velocity.z = direction.z * enemy.speed * enemy.dash_speed_multiplier
	
	enemy.move_and_slide()


func exit():
	var enemy = owner
	
	enemy.is_dashing = false
	
	# cooldown reset (from EnemyData)
	get_tree().create_timer(enemy.dash_cooldown).timeout.connect(func():
		if is_instance_valid(enemy):
			enemy.can_dash = true
	)
	
	print("Done Dashing")
