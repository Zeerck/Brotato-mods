extends Node

const AUTHORNAME_MODNAME = "RobocrafterLP-BetterDisplay"
const AUTHORNAME_MODNAME_DIR := AUTHORNAME_MODNAME
const AUTHORNAME_MODNAME_LOG_NAME := AUTHORNAME_MODNAME + ":Main"

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""

func _init() -> void:
	mod_dir_path = ModLoaderMod.get_unpacked_dir().plus_file(AUTHORNAME_MODNAME_DIR)
	# Add extensions
	install_script_extensions()
	# Add translations
	add_translations()

func install_script_extensions() -> void:
	extensions_dir_path = mod_dir_path.plus_file("extensions")
	ModLoaderMod.install_script_extension(extensions_dir_path.plus_file("ui/hud/player_ui_elements.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.plus_file("ui/hud/ui_consumable_to_process_list.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.plus_file("ui/hud/ui_upgrade_to_process_list.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.plus_file("main.gd"))


func add_translations() -> void:
	translations_dir_path = mod_dir_path.plus_file("translations")

func _ready() -> void:
	ModLoaderLog.info("Ready!", AUTHORNAME_MODNAME_LOG_NAME)
