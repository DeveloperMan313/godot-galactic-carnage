extends MultiplayerSynchronizer


const physics_interp_coef = 0.5
const position_interp_delta = 50
const rotation_interp_delta = PI

@export var server_linear_velocity: Vector2
@export var server_position: Vector2
@export var server_angular_velocity: float
@export var server_rotation: float

var new_physics_sync := false


func _ready():
	connect("synchronized", on_synchronized)


func physics_sync(rb: RigidBody2D) -> bool:
	if multiplayer.get_unique_id() == 1:
		server_physics_sync(rb)
		return false
	if not new_physics_sync:
		return false
	client_physics_sync(rb)
	return true


func server_physics_sync(rb: RigidBody2D):
	server_linear_velocity = rb.linear_velocity
	server_position = rb.position
	server_angular_velocity = rb.angular_velocity
	server_rotation = rb.rotation


func interpolate(a: Variant, b: Variant, n: float) -> Variant:
	return a * (1 - n) + b * n


func client_physics_sync(rb: RigidBody2D):
	if (rb.position - server_position).length() < position_interp_delta:
		rb.position = interpolate(rb.position, \
			server_position, physics_interp_coef)
	else:
		rb.position = server_position

	rb.linear_velocity = interpolate(rb.linear_velocity, \
		server_linear_velocity, physics_interp_coef)

	if abs(rb.rotation - server_rotation) < rotation_interp_delta:
		rb.rotation = interpolate(rb.rotation, \
			server_rotation, physics_interp_coef)
	else:
		rb.rotation = server_rotation
	new_physics_sync = false


func on_synchronized():
	new_physics_sync = true
