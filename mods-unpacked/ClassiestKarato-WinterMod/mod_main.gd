extends Node

# Brief overview of what your mod does...

# ! Comments prefixed with "!" mean they are extra info. Comments without them
# ! should be kept because they give your mod structure and make it easier to
# ! read by other modders


const MOD_DIR = "ClassiestKarato-WinterMod/" # name of the folder that this file is in
const MYMOD_LOG = "ClassiestKarato-WinterMod" # full ID of your mod (AuthorName-ModName)


var dir = ""
var ext_dir = ""
var translations = ""

# Config/Art
var mod_options

var load_cache := {"loaded_winter":false,"loaded_default":false}
#

func _init()->void:
	dir = ModLoaderMod.get_unpacked_dir().plus_file(MOD_DIR)
	install_script_extensions()
	add_translations()


func _ready()->void:
	ModLoaderLog.info("Ready", MYMOD_LOG)
	
	#Handles the config upon starting
	init_config()
	
	
	# ! This uses Godot's native `tr` func, which translates a string. You'll
	# ! find this particular string in the example CSV here: translations/modname.csv
	ModLoaderLog.info(str("Translation Demo: ", tr("WINTERMOD_READY_TEXT")), MYMOD_LOG)
	
	var ContentLoader = get_node("/root/ModLoader/Darkly77-ContentLoader/ContentLoader")
	ContentLoader.load_data(dir + "content_data/winter_mod_resources.tres", MYMOD_LOG)


func add_translations() -> void:
	translations = dir.plus_file("translations")
	ModLoaderMod.add_translation(translations.plus_file("winter-mod.en.translation"))


func install_script_extensions() -> void:
	ext_dir = dir.plus_file("extensions")
	ModLoaderMod.install_script_extension(ext_dir + "/main.gd")
	ModLoaderMod.install_script_extension(ext_dir + "/player.gd")
	ModLoaderMod.install_script_extension(ext_dir + "/player_run_data.gd")
	ModLoaderMod.install_script_extension(ext_dir + "/run_data.gd")


#Art Swap
func load_swap_art() -> void:
	if !load_cache["loaded_winter"]:
		load_cache["winter_tree"] = load("res://mods-unpacked/ClassiestKarato-WinterMod/winter_art_assets/tree/tree_animated.tres")
		load_cache["loaded_winter"] = true

func load_vanilla_art() -> void:
	if !load_cache["loaded_default"]:
		load_cache["default_tree"] = load("res://entities/units/neutral/tree.png")
		load_cache["loaded_default"] = true

#Config funcs 
func init_config() -> void:
	mod_options = get_node_or_null("/root/ModLoader/dami-ModOptions/ModsConfigInterface")
	
	var config := resolve_active_config()
	ModLoaderConfig.set_current_config(config)
	
	if mod_options:
		if config.data["WINTERMOD_TEXTURE_SWAP"] == "WINTERMOD_WINTER":
			load_swap_art()
		else:
			load_vanilla_art()
		mod_options.connect("setting_changed", self, "_on_mod_options_setting_changed")
	else:
		load_swap_art()


func resolve_active_config() -> ModConfig:
	var current := ModLoaderConfig.get_current_config(MYMOD_LOG)
	
	# No config exists at all -> start with default
	if current == null:
		ModLoaderLog.debug("No existing config detected loading default", MYMOD_LOG)
		var result_default = ModLoaderConfig.get_default_config(MYMOD_LOG)
		return result_default
	
	# If ModOptions is available -> use or create custom config
	if mod_options:
		ModLoaderLog.debug("ModOptions enabled ensuring custom config exists", MYMOD_LOG)
		var result_custom = ensure_custom_config()
		return result_custom
	var safe_default = ModLoaderConfig.get_default_config(MYMOD_LOG)
	return safe_default


func ensure_custom_config(config_name: String = "custom",debug_log : bool = true) -> ModConfig:
	var current_name := ModLoaderConfig.get_current_config_name(MYMOD_LOG)
	
	# Already custom -> nothing to do
	if current_name == config_name:
		if debug_log:
			ModLoaderLog.debug("Custom config already active (" + current_name + ") -> no action needed", MYMOD_LOG)
		return ModLoaderConfig.get_current_config(MYMOD_LOG)
	
	# If custom config exists already -> switch to it
	var existing = ModLoaderConfig.get_config(MYMOD_LOG, config_name)
	if existing:
		if debug_log:
			ModLoaderLog.debug("Existing custom config found (" + existing.name + ") -> using it.", MYMOD_LOG)
		return existing
	
	# Create new custom config
	if debug_log:
		ModLoaderLog.debug("Creating new custom config", MYMOD_LOG)
	var new_config = ModLoaderConfig.create_config(
		MYMOD_LOG,
		config_name,
		ModLoaderConfig.get_default_config(MYMOD_LOG).data
	)
	if debug_log:
		ModLoaderLog.debug("New custom config created -> " + new_config.name, MYMOD_LOG)
	return new_config

func _on_mod_options_setting_changed(setting_name, value, mod_name) -> void:
	if mod_name != MYMOD_LOG:
		return
	
	ModLoaderLog.debug("ModOption changed: " + setting_name + " -> " + str(value), MYMOD_LOG)
	
	var config := ensure_custom_config("custom",false)
	config.data[setting_name] = value
	ModLoaderConfig.update_config(config)
	if value == "WINTERMOD_WINTER":
		load_swap_art()
	else:
		load_vanilla_art()
