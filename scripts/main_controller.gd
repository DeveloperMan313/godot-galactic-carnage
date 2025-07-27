extends Node

signal match_started

const PLAYER_SCENE = preload("res://scenes/objects/player.tscn")

@onready var map = $Map


func _on_peer_connected(id: int) -> void:
	add_player(id)


func _on_peer_disconnected(id: int) -> void:
	delete_player(id)


func _on_ui_connect(address: String, port: int) -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	multiplayer.connect("connected_to_server", _on_connected_to_server)
	multiplayer.connect("connection_failed", _on_connection_failed)
	multiplayer.connect("server_disconnected", _on_server_disconnected)
	multiplayer.multiplayer_peer = peer


func _on_connected_to_server() -> void:
	match_started.emit()
	print("connected to server")


func _on_connection_failed() -> void:
	multiplayer.multiplayer_peer = null
	print("failed to connect to server")


func _on_server_disconnected() -> void:
	multiplayer.disconnect("connected_to_server", _on_connected_to_server)
	multiplayer.disconnect("connection_failed", _on_connection_failed)
	multiplayer.disconnect("server_disconnected", _on_server_disconnected)
	multiplayer.multiplayer_peer = null


func _on_ui_host(port: int) -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	multiplayer.connect("peer_connected", _on_peer_connected)
	multiplayer.connect("peer_disconnected", _on_peer_disconnected)
	print("hosting on port ", port)
	if not OS.has_feature("dedicated_server"):
		add_player(1)
	match_started.emit()


func add_player(id: int) -> void:
	var player = PLAYER_SCENE.instantiate()
	player.id = id
	player.name = str(id)
	player.position = Vector2(200, 200)
	map.add_child(player)


func delete_player(id: int) -> void:
	var player_name = str(id)
	if not map.has_node(player_name):
		return
	map.get_node(player_name).queue_free()


func _exit_tree():
	if not multiplayer.is_server():
		return
	multiplayer.disconnect("peer_connected", _on_peer_connected)
	multiplayer.disconnect("peer_disconnected", _on_peer_disconnected)
