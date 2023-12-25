extends RigidBody2D


const projectile_scene = preload("res://projectile.tscn")

const thrust = 300
const friction = 1
const rot_speed = PI * 1.5
const projectile_speed = 1000
const projectile_spawn_margin = 5
const max_ammo = 3
const reload_time = 1

var hb_radius: float
var ang_vel := 0.0
var rot_dir := 1
var reload_timer := Timer.new()
var ammo := 0


func _ready() -> void:
	hb_radius = $CollisionShape2D.shape.radius
	reload_timer.one_shot = true
	reload_timer.timeout.connect(reload)
	add_child(reload_timer)
	reload_timer.start(reload_time)
	connect("body_entered", on_collision)
	$AmmoIndicator.init_ammo_indicator()


func _physics_process(_delta) -> void:
	angular_velocity = ang_vel
	apply_central_force(Vector2.RIGHT.rotated(rotation) * thrust \
		- friction * linear_velocity)


func _input(event) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				ang_vel = rot_dir * rot_speed
			else:
				ang_vel = 0
		elif event.button_index == 2 and event.pressed:
				try_shoot()


func try_shoot() -> void:
	reload_timer.start(reload_time)
	if ammo == 0:
		return
	var dir = Vector2.RIGHT.rotated(rotation)
	var projectile = projectile_scene.instantiate()
	projectile.rotation = rotation
	projectile.linear_velocity = dir * projectile_speed
	projectile.position = position + dir * (hb_radius + \
		projectile.get_node("CollisionShape2D").shape.radius + \
		projectile_spawn_margin)
	var impulse = projectile.linear_velocity * projectile.mass
	projectile.apply_central_impulse(impulse)
	get_tree().root.get_child(0).add_child(projectile)
	apply_central_impulse(-impulse)
	ammo -= 1
	$AmmoIndicator.update(ammo)


func reload() -> void:
	ammo += 1
	$AmmoIndicator.update(ammo)
	if ammo < max_ammo:
		reload_timer.start(reload_time)


func on_collision(body: Node) -> void:
	if body.is_in_group("damage"):
		queue_free()
