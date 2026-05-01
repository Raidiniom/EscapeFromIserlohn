# enemy.gd
extends CharacterBody3D

@export_category("Enemy Stats")
@export var health : float = 100.0
@export var speed : float = 2.5
@export var armor : float = 1.0
@export var attack_damage : float = 2.0
@export var attack_speed : float = 1.0
@export var attack_range : float = 1.0
@export var gravity : float = 9.8

var player_target: Node3D = null
var can_attack := true
var is_dead : bool = false
var target_offset: Vector3

# Enemy Parts
@onready var navigation: NavigationAgent3D = $NavigationAgent3D
@onready var attack_area: Area3D = $AttackArea
@onready var state_machine = $StateMachine
@onready var health_display = $Label3D

func _ready() -> void:
	health_display.text = str(health)
	
	var radius = 2.0
	target_offset = Vector3(
		randf_range(-radius, radius),
		0,
		randf_range(-radius, radius)
	)
	
	#var player = get_tree().get_nodes_in_group("player")
	#
	#if player.size() > 0:
		#player_target = player[0]
		#state_machine.change_state("chase")
	

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	print("GLOBAL POS:", global_position)
	

func move_to_target(delta):
	if player_target == null:
		return
	
	var target_pos = player_target.global_position + target_offset
	var to_target = target_pos - global_position
	to_target.y = 0
	
	var distance = to_target.length()
	
	if distance <= attack_range:
		velocity.x = 0
		velocity.y = 0
		return
	
	var direction = to_target.normalized()
	
	var separation = get_separation_force()
	
	# Blend movement + separation
	direction += separation * 1.5
	direction = direction.normalized()
	
	var slow_radius = attack_range + 1.5
	var move_speed = speed
	
	if distance < slow_radius:
		move_speed = speed * (distance / slow_radius)
	
	if direction.length() > 0.01:
		var target_basis = Basis().looking_at(direction, Vector3.UP)
		transform.basis = transform.basis.slerp(target_basis, 5 * delta)
	
	
	velocity.x = direction.x * move_speed
	velocity.z = direction.z * move_speed
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
	
	print(player_target)
	print(velocity)
	
	move_and_slide()
	

func get_separation_force() -> Vector3:
	var separation_radius = 2.0
	var force = Vector3.ZERO
	
	for other in get_tree().get_nodes_in_group("enemy"):
		if other == self:
			continue
		
		var diff = global_position - other.global_position
		var dist = diff.length()
		
		if dist > 0 and dist < separation_radius:
			force += diff.normalized() / dist
	
	return force

func take_damage(amount: float):
	health -= amount
	
	health_display.text = str(health)
	if health <= 0 and !is_dead:
		die()

func die():
	is_dead = true
	
	GameManager.enemies_alive -= 1
	
	if GameManager.enemies_alive <= 0:
		GameManager.next_round()
	
	queue_free()

func _on_attack_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		can_attack = true
