extends Node

# Brief overview of what your mod does...

# ! Comments prefixed with "!" mean they are extra info. Comments without them
# ! should be kept because they give your mod structure and make it easier to
# ! read by other modders


const MOD_DIR = "ClassiestKarato-WinterMod/" # name of the folder that this file is in
const MYMOD_LOG = "ClassiestKarato-WinterMod" # full ID of your mod (AuthorName-ModName)


var dir = ""
var ext_dir = ""


func _ready()->void:
	ModLoaderLog.info("Ready", MYMOD_LOG)

	# ! This uses Godot's native `tr` func, which translates a string. You'll
	# ! find this particular string in the example CSV here: translations/modname.csv
	ModLoaderLog.info(str("Translation Demo: ", tr("WINTERMOD_READY_TEXT")), MYMOD_LOG)
	
	var ContentLoader = get_node("/root/ModLoader/Darkly77-ContentLoader/ContentLoader")
	ContentLoader.load_data(dir + "res://mods-unpacked/ClassiestKarato-WinterMod/content_data/winter_mod_resources.tres", MYMOD_LOG)
