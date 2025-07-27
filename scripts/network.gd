extends Node


@onready var room = $"../Room"


func _on_peer_connected(id: int) -> void:
	room.add_player(id)


func _on_peer_disconnected(id: int) -> void:
	room.delete_player(id)


func _on_ui_connect(address: String, port: int) -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	multiplayer.connect("connected_to_server", _on_connected_to_server)
	multiplayer.connect("connection_failed", _on_connection_failed)
	multiplayer.connect("server_disconnected", _on_server_disconnected)
	multiplayer.multiplayer_peer = peer


func _on_connected_to_server() -> void:
	room.start_match()
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
		room.add_player(1)
	room.start_match()


func _exit_tree():
	if not multiplayer.is_server():
		return
	multiplayer.disconnect("peer_connected", _on_peer_connected)
	multiplayer.disconnect("peer_disconnected", _on_peer_disconnected)
