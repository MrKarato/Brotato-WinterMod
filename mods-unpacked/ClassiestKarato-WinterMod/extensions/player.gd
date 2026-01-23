extends "res://entities/units/player/player.gd"

func on_consumable_picked_up(consumable_data: ConsumableData) -> void :
	var crate_stats = RunData.get_player_effect("wintermod_santa_melee_on_crate", player_index)
	
	if crate_stats.size() > 0:
		for i in crate_stats.size():
			var stat = crate_stats[i]
			RunData.add_stat(stat[0], stat[1], player_index)
			RunData.add_tracked_value(player_index, "wintermod_character_santa", stat[1])
	
	.on_consumable_picked_up(consumable_data)
