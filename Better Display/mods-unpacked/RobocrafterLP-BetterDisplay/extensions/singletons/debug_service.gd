extends "res://singletons/debug_service.gd"

func _ready() -> void:
    var AUTHORNAME_MODNAME = "RobocrafterLP-BetterDisplay"
    var AUTHORNAME_MODNAME_DIR = AUTHORNAME_MODNAME
    var mod_dir_path = ModLoaderMod.get_unpacked_dir().plus_file(AUTHORNAME_MODNAME_DIR)
    var extensions_dir_path = mod_dir_path.plus_file("extensions")

    var extensions = [
	]
	
    for extension in extensions:
        ModLoaderMod.install_script_extension(extensions_dir_path.plus_file(extension))