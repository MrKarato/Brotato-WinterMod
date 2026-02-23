extends "res://main.gd"

var turret_flame_effect = load("res://items/all/turret_flame/turret_flame_effect_1.tres")
var turret_laser_effect = load("res://items/all/turret_laser/turret_laser_effect_1.tres")
var turret_rocket_effect = load("res://items/all/turret_rocket/turret_rocket_effect_1.tres")

var winter_mod
var winter_mod_config 

func _ready():
	winter_mod = get_node_or_null("/root/ModLoader/ClassiestKarato-WinterMod")
	winter_mod_config = ModLoaderConfig.get_current_config("ClassiestKarato-WinterMod")

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

func _wintermod_swap_tree_sprite(neutral: Neutral) -> void:
	if "tree" in neutral.filename:
		if winter_mod and winter_mod_config:
			if winter_mod_config.data["WINTERMOD_TEXTURE_SWAP"] == "WINTERMOD_WINTER":
				neutral.sprite.texture = winter_mod.load_cache["winter_tree"]
			else:
				neutral.sprite.texture = winter_mod.load_cache["default_tree"]

func _on_EntitySpawner_neutral_spawned(neutral: Neutral) -> void :
	_wintermod_swap_tree_sprite(neutral)
	._on_EntitySpawner_neutral_spawned(neutral)

func _on_EntitySpawner_neutral_respawned(neutral: Neutral) -> void :
	_wintermod_swap_tree_sprite(neutral)
	._on_EntitySpawner_neutral_respawned(neutral)

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
	return RunData.get_player_character(player_index).my_id == "wintermod_character_toymaker"
	
# This is unchanged except to skip Santa. If another mod interacts with this code, it is incompatible.
func on_consumable_picked_up(consumable: Node, player_index: int) -> void:
	if consumable.already_picked_up:
		return

	consumable.already_picked_up = true
	_consumables.erase(consumable)
	add_node_to_pool(consumable)

	var item_box_gold_effect = RunData.get_player_effect("item_box_gold", player_index)
	if (consumable.consumable_data.my_id == "consumable_item_box" or consumable.consumable_data.my_id == "consumable_legendary_item_box") and item_box_gold_effect != 0:
		RunData.add_gold(item_box_gold_effect, player_index)
		RunData.add_tracked_value(player_index, "item_bag", item_box_gold_effect)

	var consumable_data = consumable.consumable_data
	if consumable_data.to_be_processed_at_end_of_wave:
		var consumable_to_process = UpgradesUI.ConsumableToProcess.new()
		consumable_to_process.consumable_data = consumable_data

		var player_index_to_add_to = player_index

		if ProgressData.settings.share_coop_loot:
			# Check which players can receive crates.
			var valid_players = RunData.wintermod_get_crate_players()
			# If none can (All Santas), let all of them receive crates.
			if valid_players.size() == 0:
				for i in RunData.get_player_count():
					valid_players.append(i)
			# Gets the index of a random crate receiving player.
			player_index_to_add_to = valid_players[randi() % valid_players.size()]

			# Checks if any other crate receiving player has less crates, gives it to that player if found.
			for i in valid_players:
				if _consumables_to_process[i].size() < _consumables_to_process[player_index_to_add_to].size():
					player_index_to_add_to = i

		consumable_to_process.player_index = player_index_to_add_to
		_consumables_to_process[player_index_to_add_to].push_back(consumable_to_process)
		_things_to_process_player_containers[player_index_to_add_to].consumables.add_element(consumable_data)

	_players[player_index].on_consumable_picked_up(consumable_data)

	if not _cleaning_up:
		RunData.handle_explode_effect("explode_on_consumable", consumable.global_position, player_index)
		RunData.handle_explode_effect("explode_on_consumable_burning", consumable.global_position, player_index)

	RunData.apply_item_effects(consumable.consumable_data, player_index)
