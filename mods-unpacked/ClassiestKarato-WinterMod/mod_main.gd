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


func _init()->void:
	dir = ModLoaderMod.get_unpacked_dir().plus_file(MOD_DIR)
	install_script_extensions()
	add_translations()


func _ready()->void:
	ModLoaderLog.info("Ready", MYMOD_LOG)

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
