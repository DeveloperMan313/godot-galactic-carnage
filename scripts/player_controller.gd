extends Control


@export var color: Color

@onready var button_move = $ButtonMove

func _ready():
	button_move.material.set_shader_parameter("color", color)
