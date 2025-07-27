extends Node

signal connect(address, port)
signal host(port)

@onready var option_menu = $OptionMenu
@onready var connect_menu = $ConnectMenu
@onready var connect_address = $ConnectMenu/Address
@onready var connect_port = $ConnectMenu/Port
@onready var host_menu = $HostMenu
@onready var host_port = $HostMenu/Port


func _ready():
	option_menu.visible = true


func hide_menus():
	option_menu.visible = false
	connect_menu.visible = false
	host_menu.visible = false


func _on_connect_pressed():
	hide_menus()
	connect_menu.visible = true


func _on_host_pressed():
	hide_menus()
	host_menu.visible = true


func _on_connect_confirm_pressed():
	var address: String = connect_address.text
	var port: int = int(connect_port.text)
	connect.emit(address, port)


func _on_host_confirm_pressed():
	var port: int = int(host_port.text)
	host.emit(port)


func _on_room_match_started():
	hide_menus()


func _on_back_to_multiplayer_pressed():
	hide_menus()
	option_menu.visible = true
