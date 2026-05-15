# charge_state.gd
extends State

var charge_direction: Vector3 = Vector3.ZERO
var charge_timer: float = 0.0
var windup_timer: float = 0.0
var is_winding_up: bool = true

const WINDUP_DURATION: float = 1.0
const CHARGE_DURATION: float = 1.5

func enter():
	var enemy = owner
	is_winding_up = true
	windup_timer = WINDUP_DURATION
	charge_timer = CHARGE_DURATION
	enemy.charge_ready = false
	
	# Lock direction at the moment of entering
	if enemy.player_target:
		charge_direction = (
			enemy.player_target.global_position - enemy.global_position
		).normalized()
		charge_direction.y = 0

func physics_process(delta):
	var enemy = owner
	
	# Windup — freeze briefly before charging
	if is_winding_up:
		enemy.velocity.x = 0
		enemy.velocity.z = 0
		windup_timer -= delta
		if windup_timer <= 0:
			is_winding_up = false
		return
	
	# Charge
	charge_timer -= delta
	
	if charge_timer <= 0:
		state_machine.change_state("chase")
		return
	
	var charge_speed = enemy.speed * enemy.charge_speed_multiplier
	enemy.velocity.x = charge_direction.x * charge_speed
	enemy.velocity.z = charge_direction.z * charge_speed
	
	if not enemy.is_on_floor():
		enemy.velocity.y -= enemy.gravity * delta
	else:
		enemy.velocity.y = 0
	
	enemy.move_and_slide()
	
	# Hit anything in the way
	for i in enemy.get_slide_collision_count():
		var col = enemy.get_slide_collision(i)
		var collider = col.get_collider()
		if collider != enemy and collider.has_method("take_damage"):
			collider.take_damage(enemy.attack_damage * 2.0)

func exit():
	var enemy = owner
	# Start cooldown
	var timer = get_tree().create_timer(enemy.charge_cooldown)
	timer.timeout.connect(func():
		if is_instance_valid(enemy):
			enemy.charge_ready = true
	)
	
