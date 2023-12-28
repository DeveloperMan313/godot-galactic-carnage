extends RigidBody2D


@onready var physics_synchronizer = $PhysicsSynchronizer


func _ready():
	connect("body_entered", on_collision)
	set_multiplayer_authority(1)
	set_physics_process(multiplayer.is_server())


func _physics_process(_delta):
	physics_synchronizer.server_physics_sync(self)


func _integrate_forces(_state):
	physics_synchronizer.client_physics_sync(self)


func on_collision(_body: Node) -> void:
	if multiplayer.is_server():
		queue_free()
