extends Node


const PORT = 55555
const PLAYER_SCENE = preload("res://scenes/objects/player.tscn")

@onready var multiplayer_option_menu = $UI/MultiplayerOptionMenu
@onready var map = $Map


func _ready():
	multiplayer_option_menu.visible = true


func on_peer_connected(id: int) -> void:
	add_player(id)


func on_peer_disconnected(id: int) -> void:
	delete_player(id)


func on_connect_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	var ip = "127.0.0.1"
	peer.create_client(ip, PORT)
	multiplayer.connect("connected_to_server", on_connected_to_server)
	multiplayer.connect("connection_failed", on_connection_failed)
	multiplayer.connect("server_disconnected", on_server_disconnected)
	multiplayer.multiplayer_peer = peer
	multiplayer_option_menu.visible = false


func on_connected_to_server() -> void:
	print("connected to server")


func on_connection_failed() -> void:
	multiplayer.multiplayer_peer = null
	multiplayer_option_menu.visible = true


func on_server_disconnected() -> void:
	multiplayer.disconnect("connected_to_server", on_connected_to_server)
	multiplayer.disconnect("connection_failed", on_connection_failed)
	multiplayer.disconnect("server_disconnected", on_server_disconnected)
	multiplayer.multiplayer_peer = null
	multiplayer_option_menu.visible = true


func on_host_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.connect("peer_connected", on_peer_connected)
	multiplayer.connect("peer_disconnected", on_peer_disconnected)
	print("hosting on port ", PORT)
	multiplayer_option_menu.visible = false
	if not OS.has_feature("dedicated_server"):
		add_player(1)


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
	multiplayer.disconnect("peer_connected", on_peer_connected)
	multiplayer.disconnect("peer_disconnected", on_peer_disconnected)
