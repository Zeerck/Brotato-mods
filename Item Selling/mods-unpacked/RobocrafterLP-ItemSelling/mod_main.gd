extends Node

const AUTHORNAME_MODNAME = "RobocrafterLP-ItemSelling"
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

	ModLoaderMod.install_script_extension(extensions_dir_path.plus_file("ui/menus/shop/inventory.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.plus_file("ui/menus/shop/item_popup.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.plus_file("ui/menus/shop/coop_item_popup.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.plus_file("singletons/debug_service.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.plus_file("singletons/run_data.gd"))



func add_translations() -> void:
	translations_dir_path = mod_dir_path.plus_file("translations")


func _ready() -> void:
	ModLoaderLog.info("Ready!", AUTHORNAME_MODNAME_LOG_NAME)
