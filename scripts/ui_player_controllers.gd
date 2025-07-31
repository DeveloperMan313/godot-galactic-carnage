extends Node


@onready var controllers = [$Controller0, $Controller1, $Controller2, $Controller3]


func bind_controller_to_player(player: GamePlayer):
	var slot_idx = player.slot_idx
	assert(0 <= slot_idx and slot_idx <= 3)
	controllers[slot_idx].bind_to_player(player)
