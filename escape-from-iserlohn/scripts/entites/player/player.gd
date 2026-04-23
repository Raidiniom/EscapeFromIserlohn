extends CharacterBody3D

# Player stats
@export var health: float = 100.0
@export var base_damage: float = 15.0
@export var attack_speed: float = 2.5
@export var movement_speed: float = 5.0
@export var luck_stat: float = 2.0

# Utilities
@export var gravity: float = 9.8
@export var mouse_sensitivity: float = 0.002

# Camera
@onready var spring_arm: SpringArm3D = $SpringArm3D
@onready var camera_3d: Camera3D = $SpringArm3D/Camera3D
@onready var raycast_3d: RayCast3D = $SpringArm3D/Camera3D/RayCast3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)

		spring_arm.rotate_x(-event.relative.y * mouse_sensitivity)
		spring_arm.rotation.x = clamp(
			spring_arm.rotation.x,
			deg_to_rad(-70),
			deg_to_rad(25)
		)

func can_plant() -> bool:
	if raycast_3d.is_colliding():
		var collider = raycast_3d.get_collider()
		
		print("Hit: ", collider)
		
		return collider.is_in_group("plantable_ground")
	
	return false

func get_plant_position() -> Vector3:
	return raycast_3d.get_collision_point()
