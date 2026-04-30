extends CharacterBody3D

@export_category("Enemy Stats")
@export var health : float = 25.0
@export var speed : float = 2.5
@export var attack_damage : float = 2.0
@export var attack_speed : float = 1.0

var player_target: Node3D = null
var can_attack := true
var is_dead := false

@onready var navigation: NavigationAgent3D = $NavigationAgent3D
@onready var attack_area: Area3D = $Area3D
@onready var state_machine = $StateMachine

func _ready() -> void:
	player_target = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	pass

func take_damage(amount: float):
	health -= amount
	
	if health <= 0 and !is_dead:
		die()

func die():
	is_dead = true
	
	GameManager.enemies_alive -= 1
	
	if GameManager.enemies_alive <= 0:
		GameManager.next_round()
	
	queue_free()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_target = body
		state_machine.change_state("chase")
	
