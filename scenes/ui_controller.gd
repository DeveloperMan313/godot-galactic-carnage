extends Node

signal connect(address, port)
signal host(port)

@onready var multiplayer_option_menu = $MultiplayerOptionMenu
@onready var multiplayer_connect_menu = $MultiplayerConnectMenu
@onready var multiplayer_connect_address = $MultiplayerConnectMenu/Address
@onready var multiplayer_connect_port = $MultiplayerConnectMenu/Port
@onready var multiplayer_host_menu = $MultiplayerHostMenu
@onready var multiplayer_host_port = $MultiplayerHostMenu/Port


func _ready():
	multiplayer_option_menu.visible = true


func hide_menus():
	multiplayer_option_menu.visible = false
	multiplayer_connect_menu.visible = false
	multiplayer_host_menu.visible = false


func _on_connect_pressed():
	hide_menus()
	multiplayer_connect_menu.visible = true


func _on_host_pressed():
	hide_menus()
	multiplayer_host_menu.visible = true


func _on_connect_confirm_pressed():
	var address: String = multiplayer_connect_address.text
	var port: int = int(multiplayer_connect_port.text)
	connect.emit(address, port)


func _on_host_confirm_pressed():
	var port: int = int(multiplayer_host_port.text)
	host.emit(port)


func _on_main_controller_match_started():
	hide_menus()


func _on_back_to_multiplayer_pressed():
	hide_menus()
	multiplayer_option_menu.visible = true
