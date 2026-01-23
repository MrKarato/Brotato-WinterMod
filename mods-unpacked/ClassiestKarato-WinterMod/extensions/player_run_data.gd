extends "res://singletons/player_run_data.gd"

static func init_effects() -> Dictionary:
	var all_effects = .init_effects()
	var winter_mod_effects = {
		"wintermod_santa_melee_on_crate": []
	}
	all_effects.merge(winter_mod_effects)
	return all_effects
