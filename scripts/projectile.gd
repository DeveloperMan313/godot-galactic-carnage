extends RigidBody2D


@onready var physics_synchronizer = $PhysicsSynchronizer
@onready var edge_warp = $EdgeWarp


func _ready():
	connect("body_entered", _on_collision)


func _integrate_forces(_state):
	if multiplayer.is_server():
		edge_warp.warp(self)
	physics_synchronizer.physics_sync(self)


func _on_collision(_body: Node) -> void:
	if multiplayer.is_server():
		queue_free()
