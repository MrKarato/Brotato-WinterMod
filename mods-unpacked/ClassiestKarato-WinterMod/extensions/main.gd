extends "res://main.gd"


func on_item_box_discard_button_pressed(item_data: ItemParentData, consumable: UpgradesUI.ConsumableToProcess) -> void :
	var player_index = consumable.player_index
	var value = ItemService.get_recycling_value(RunData.current_wave, item_data.value, player_index)
	RunData.add_gold(value, player_index)
	RunData.update_recycling_tracking_value(item_data, player_index)
	
	if RunData.get_player_character(player_index).my_id == "character_toymaker":
		RunData.add_stat("stat_engineering", 1, player_index)


func on_item_box_ban_button_pressed(item_data: ItemParentData, consumable: UpgradesUI.ConsumableToProcess) -> void :
	var player_index = consumable.player_index
	var value = floor(ItemService.get_recycling_value(RunData.current_wave, item_data.value, player_index))
	var player_run_data = RunData.players_data[player_index]
	player_run_data.banned_items.push_back(item_data.my_id)
	player_run_data.remaining_ban_token -= 1
	RunData.add_gold(value, player_index)
	RunData.update_recycling_tracking_value(item_data, player_index)

	if RunData.get_player_character(player_index).my_id == "character_toymaker":
		RunData.add_stat("stat_engineering", 1, player_index)
