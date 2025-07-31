extends Control


signal rotation_start
signal rotation_stop
signal shoot

@onready var shader_material = $ButtonRotate.material


func bind_to_player(player: GamePlayer):
	rotation_start.connect(player._on_player_controller_rotation_start)
	rotation_stop.connect(player._on_player_controller_rotation_stop)
	shoot.connect(player._on_player_controller_shoot)
	shader_material.set_shader_parameter("color", player.color)
	show()


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				rotation_start.emit()
			else:
				rotation_stop.emit()
		elif event.button_index == 2 and event.pressed:
				shoot.emit()


func _on_button_rotate_pressed():
	rotation_start.emit()


func _on_button_rotate_released():
	rotation_stop.emit()


func _on_button_shoot_pressed():
	shoot.emit()
