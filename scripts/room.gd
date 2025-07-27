extends Node

signal match_started

const PLAYER_SCENE = preload("res://scenes/objects/player.tscn")

@onready var map = $Map


func add_player(id: int) -> void:
	var player = PLAYER_SCENE.instantiate()
	player.id = id
	player.name = str(id)
	player.position = Vector2(200, 200)
	map.add_child(player, true)


func delete_player(id: int) -> void:
	var player_name = str(id)
	if not map.has_node(player_name):
		return
	map.get_node(player_name).queue_free()


func start_match():
	match_started.emit()
