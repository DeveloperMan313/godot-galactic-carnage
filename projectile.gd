extends RigidBody2D


func _ready() -> void:
	connect("body_entered", on_collision)


func on_collision(_body: Node) -> void:
	queue_free()
