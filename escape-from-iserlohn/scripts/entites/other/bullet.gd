extends Area3D

var speed: float = 25.0
var damage: float = 15.0
var lifetime: float = 1.0
var direction: Vector3 = Vector3.ZERO
var source = null

func _ready():
	if direction != Vector3.ZERO:
		look_at(global_position + direction, Vector3.UP)
		# Arrow mesh is modeled pointing UP (+Y), so tilt it forward to align with -Z flight direction
		rotate_object_local(-Vector3.UP, deg_to_rad(90))

	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta):
	global_position += direction.normalized() * speed * delta

func _on_body_entered(body):
	if not body.has_method("take_damage"):
		queue_free()
		return
	if "team" in body and body.team == source:
		return
	body.take_damage(damage)
	queue_free()
