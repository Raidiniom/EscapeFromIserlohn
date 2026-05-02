extends Area3D

var speed: float
var damage: float
var lifetime: float
var direction: Vector3
var source: int

func _ready():
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta):
	global_position += direction * speed * delta

func _on_body_entered(body):
	if not body.has_method("take_damage"):
		print("Entity has no take_damage function!")
		return
	
	if "team" in body:
		if body.team == source:
			return
	
	body.take_damage(damage)
	
	queue_free()
