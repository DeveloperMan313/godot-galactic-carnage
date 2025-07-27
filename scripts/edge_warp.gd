extends Node


@onready var map: Node = get_tree().root.find_child("Map", true, false)
@onready var width: float = map.get_window().size.x
@onready var height: float = map.get_window().size.y


func warp(rb: RigidBody2D):
	rb.position.x = fposmod(rb.position.x, width)
	rb.position.y = fposmod(rb.position.y, height)
