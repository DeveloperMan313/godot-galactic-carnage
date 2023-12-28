extends RigidBody2D


func _ready():
	connect("body_entered", on_collision)
	set_multiplayer_authority(1)


func on_collision(_body: Node) -> void:
	if multiplayer.is_server():
		queue_free()
