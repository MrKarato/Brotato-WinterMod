extends "res://singletons/run_data.gd"

func init_tracked_effects() -> Dictionary:
	var wintermod_tracked_items = {
		"wintermod_character_santa": 0
	}
	init_tracked_items.merge(wintermod_tracked_items)
	return .init_tracked_effects()
