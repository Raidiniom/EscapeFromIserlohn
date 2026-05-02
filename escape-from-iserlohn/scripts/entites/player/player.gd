# player.gd
extends CharacterBody3D

# Player stats
@export_category("Player Stats")
@export var health : float = 100.0
@export var base_damage : float = 25.0
@export var armor : float = 1.0
@export var attack_speed : float = 3.0
@export var movement_speed : float = 6.0
@export var luck_stat : float = 2.0

# Utilities
@export_subgroup("Utilities")
@export var gravity: float = 9.8
@export var mouse_sensitivity: float = 0.002
@export var projectile_scene: PackedScene
var attack_timer : float = 0.2
var is_dead : bool = false
var team = TeamManager.Team.PLAYER

var selected_seed : int = SeedTypes.SeedType.DAMAGE

#Player Body
@onready var player_body: MeshInstance3D = $CollisionShape3D/MeshInstance3D
@onready var player_health: Label3D = $Label3D

# Camera
@onready var spring_arm: SpringArm3D = $SpringArm3D
@onready var camera_3d: Camera3D = $SpringArm3D/Camera3D
@onready var raycast_3d: RayCast3D = $SpringArm3D/Camera3D/RayCast3D

func _ready():
	update_stats_display()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	handle_auto_attack(delta)

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)

		spring_arm.rotate_x(-event.relative.y * mouse_sensitivity)
		spring_arm.rotation.x = clamp(
			spring_arm.rotation.x,
			deg_to_rad(-70),
			deg_to_rad(25)
		)
	
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_1: selected_seed = SeedTypes.SeedType.DAMAGE
			KEY_2: selected_seed = SeedTypes.SeedType.MOVEMENT
			KEY_3: selected_seed = SeedTypes.SeedType.ATTACK_SPEED
			KEY_4: selected_seed = SeedTypes.SeedType.HEALTH
			KEY_5: selected_seed = SeedTypes.SeedType.ARMOR
			KEY_6: selected_seed = SeedTypes.SeedType.LUCK
		update_stats_display()

func take_damage(amount: float):
	var final_dmg = calculate_damage(amount, armor)
	
	health -= final_dmg
	
	update_stats_display()
	
	if health <= 0:
		die()

func calculate_damage(damage: float, armor: float) -> float:
	var reduced_damage = armor / (armor + 100)
	var calculated_dmg = damage * (1 - reduced_damage)
	
	return max(1.0, calculated_dmg)

func update_stats_display():
	var display_text = "=== PLAYER STATS ===\n"
	display_text += "HP: " + str(floorf(health)) + "/100\n"
	display_text += "DMG: " + str(base_damage) + "\n"
	display_text += "Armor: " + str(armor) + "\n"
	display_text += "ATK Speed: " + str(attack_speed) + "\n"
	display_text += "Move Speed: " + str(movement_speed) + "\n"
	display_text += "Luck: " + str(luck_stat) + "\n"
	display_text += "\n=== INVENTORY ===\n"
	display_text += "[1] DMG Seeds: " + str(GameDataManager.seeds[SeedTypes.SeedType.DAMAGE]) + "\n"
	display_text += "[2] MOV Seeds: " + str(GameDataManager.seeds[SeedTypes.SeedType.MOVEMENT]) + "\n"
	display_text += "[3] ATK Seeds: " + str(GameDataManager.seeds[SeedTypes.SeedType.ATTACK_SPEED]) + "\n"
	display_text += "[4] HP Seeds: " + str(GameDataManager.seeds[SeedTypes.SeedType.HEALTH]) + "\n"
	display_text += "[5] ARM Seeds: " + str(GameDataManager.seeds[SeedTypes.SeedType.ARMOR]) + "\n"
	display_text += "[6] LUCK Seeds: " + str(GameDataManager.seeds[SeedTypes.SeedType.LUCK]) + "\n"
	display_text += "\nSelected: "
	
	match selected_seed:
		SeedTypes.SeedType.DAMAGE: display_text += "DMG"
		SeedTypes.SeedType.MOVEMENT: display_text += "MOV"
		SeedTypes.SeedType.ATTACK_SPEED: display_text += "ATK"
		SeedTypes.SeedType.HEALTH: display_text += "HP"
		SeedTypes.SeedType.ARMOR: display_text += "ARM"
		SeedTypes.SeedType.LUCK: display_text += "LUCK"
	
	player_health.text = display_text

func die():
	if is_dead:
		return
	
	is_dead = true
	print("[DEBUG] Player Died!!!")
	

func respawn():
	pass
	

func can_plant() -> bool:
	if raycast_3d.is_colliding():
		var collider = raycast_3d.get_collider()
		
		return collider.is_in_group("plantable_ground")
	
	return false

func get_plant_position() -> Vector3:
	return raycast_3d.get_collision_point()

func handle_auto_attack(delta):
	attack_timer -= delta

	if attack_timer <= 0:
		fire_projectile()
		attack_timer = 1.0 / attack_speed

func fire_projectile():
	if projectile_scene == null:
		return
	
	if !is_inside_tree():
		return
	
	var projectile = projectile_scene.instantiate()
	
	var direction = -global_transform.basis.z
	var spawn_pos = global_transform.origin + direction * 1.5
	
	projectile.global_position = spawn_pos
	projectile.direction = direction.normalized()
	projectile.speed = 25.0
	projectile.damage = base_damage
	projectile.lifetime = 2.0
	projectile.source = team
	
	get_tree().current_scene.add_child(projectile)
