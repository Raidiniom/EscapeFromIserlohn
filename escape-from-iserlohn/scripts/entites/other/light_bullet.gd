extends Area3D

@export var speed: float = 20.0
@export var damage: float = 10.0
@export var lifetime: float = 3.0

var direction: Vector3

func _ready():
	# Auto delete after some time
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta):
	global_position += direction * speed * delta

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	
	queue_free()
