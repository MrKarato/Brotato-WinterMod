extends "res://main.gd"

var turret_flame_effect = load("res://items/all/turret_flame/turret_flame_effect_1.tres")
var turret_laser_effect = load("res://items/all/turret_laser/turret_laser_effect_1.tres")
var turret_rocket_effect = load("res://items/all/turret_rocket/turret_rocket_effect_1.tres")

func on_item_box_discard_button_pressed(item_data: ItemParentData, consumable: UpgradesUI.ConsumableToProcess) -> void :
	var player_index = consumable.player_index
	if isToyMaker(player_index):
		var value = item_data.tier + 1
		RunData.add_stat("stat_engineering", value, player_index)

	.on_item_box_discard_button_pressed(item_data, consumable)


func on_item_box_ban_button_pressed(item_data: ItemParentData, consumable: UpgradesUI.ConsumableToProcess) -> void :
	var player_index = consumable.player_index
	if isToyMaker(player_index):
		RunData.add_stat("stat_engineering", 1, player_index)
	
	.on_item_box_ban_button_pressed(item_data, consumable)


func _on_neutral_died(neutral: Neutral, args: Entity.DieArgs) -> void :
	if not _cleaning_up:
		for player in _get_shuffled_live_players():
			var player_index = player.player_index
		
			if isToyMaker(player_index):
				var pos = _entity_spawner.get_spawn_pos_in_area(neutral.global_position, 200)
				var queue = _entity_spawner.queues_to_spawn_structures[player_index]
				var turret_resource = getToyMakerTurret(player_index)
				queue.push_back([EntityType.STRUCTURE, turret_resource.scene, pos, turret_resource])
	
	._on_neutral_died(neutral, args)


func getToyMakerTurret(player_index: int) -> Resource:
	var engineering = Utils.get_stat("stat_engineering", player_index)

	if engineering >= 25 and engineering < 50:
		return turret_flame_effect
	elif engineering >= 50 and engineering < 75:
		return turret_laser_effect
	elif engineering >= 75:
		return turret_rocket_effect
	else:
		return turret_effect


func isToyMaker(player_index: int) -> bool:
	return RunData.get_player_character(player_index).my_id == "character_toymaker"
