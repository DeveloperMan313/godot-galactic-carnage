extends RigidBody2D


const projectile_scene = preload("res://scenes/objects/projectile.tscn")

const thrust = 300
const friction = 1
const rot_speed = PI * 1.5
const projectile_speed = 1000
const projectile_spawn_margin = 5
const max_ammo = 3
const reload_time = 1

@export var id := 1 :
	set(new_id):
		id = new_id
		set_multiplayer_authority(id, false)

@onready var ammo_indicator = $AmmoIndicator
@onready var hb_radius: float = $CollisionShape2D.shape.radius
@onready var projectile_mass: float = projectile_scene.instantiate().mass

var ang_vel := 0.0
var rot_dir := 1
var reload_timer := Timer.new()
var ammo := 0


func _ready():
	reload_timer.one_shot = true
	reload_timer.timeout.connect(reload)
	add_child(reload_timer)
	reload_timer.start(reload_time)
	connect("body_entered", on_collision)
	ammo_indicator.init_ammo_indicator()
	$MultiplayerSynchronizer.set_multiplayer_authority(1)
	set_process_input(get_multiplayer_authority() == \
		multiplayer.get_unique_id())


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				start_rotation.rpc()
			else:
				stop_rotation.rpc()
		elif event.button_index == 2 and event.pressed:
				shoot.rpc()


func _physics_process(_delta):
	angular_velocity = ang_vel
	apply_central_force(Vector2.RIGHT.rotated(rotation) * thrust \
		- friction * linear_velocity)


@rpc("call_local")
func start_rotation() -> void:
	ang_vel = rot_dir * rot_speed


@rpc("call_local")
func stop_rotation() -> void:
	ang_vel = 0


@rpc("call_local")
func shoot() -> void:
	reload_timer.start(reload_time)
	if ammo == 0:
		return
	ammo -= 1
	ammo_indicator.update(ammo)
	var dir = Vector2.RIGHT.rotated(rotation)
	var projectile_vel = dir * projectile_speed
	var impulse = projectile_vel * projectile_mass
	apply_central_impulse(-impulse)
	if not multiplayer.is_server():
		return
	var projectile = projectile_scene.instantiate()
	projectile.rotation = rotation
	projectile.linear_velocity = projectile_vel
	projectile.position = position + dir * (hb_radius + \
		projectile.get_node("CollisionShape2D").shape.radius + \
		projectile_spawn_margin)
	projectile.apply_central_impulse(impulse)
	add_sibling(projectile, true)


func reload() -> void:
	ammo += 1
	ammo_indicator.update(ammo)
	if ammo < max_ammo:
		reload_timer.start(reload_time)


func on_collision(body: Node) -> void:
	if body.is_in_group("damage") and multiplayer.is_server():
		queue_free()
