extends MultiplayerSynchronizer


const physics_interp_coef = 0.5
const rotation_interp_delta = PI

@export var server_linear_velocity: Vector2
@export var server_position: Vector2
@export var server_angular_velocity: float
@export var server_rotation: float

var new_physics_sync := false


func _ready():
	connect("synchronized", on_synchronized)


func server_physics_sync(rb: RigidBody2D) -> void:
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		return
	server_linear_velocity = rb.linear_velocity
	server_position = rb.position
	server_angular_velocity = rb.angular_velocity
	server_rotation = rb.rotation
	new_physics_sync = true


func interpolate(a: Variant, b: Variant, n: float) -> Variant:
	return a * (1 - n) + b * n


func client_physics_sync(rb: RigidBody2D) -> bool:
	if not new_physics_sync or \
		get_multiplayer_authority() == multiplayer.get_unique_id():
		return false
	rb.position = interpolate(rb.position, \
		server_position, physics_interp_coef)
	rb.linear_velocity = interpolate(rb.linear_velocity, \
		server_linear_velocity, physics_interp_coef)
	if abs(rb.rotation - server_rotation) < rotation_interp_delta:
		rb.rotation = interpolate(rb.rotation, \
			server_rotation, physics_interp_coef)
	else:
		rb.rotation = server_rotation
	new_physics_sync = false
	return true


func on_synchronized() -> void:
	new_physics_sync = true
