extends "res://singletons/run_data.gd"

func init_tracked_effects() -> Dictionary:
	var wintermod_tracked_items = {
		"wintermod_character_santa": 0
	}
	init_tracked_items.merge(wintermod_tracked_items)
	return .init_tracked_effects()

func wintermod_get_crate_players() -> Array:
	var crate_slots = []
	for n in players_data.size():
		if get_player_character(n).name != "WINTERMOD_SANTA":
			crate_slots.append(n)
	return crate_slots
