extends Node

const RobocrafterLP_Trade= "RobocrafterLP-Trade"
const RobocrafterLP_Trade_DIR := RobocrafterLP_Trade
const RobocrafterLP_Trade_LOG_NAME := RobocrafterLP_Trade + ":Main"

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""

func _init() -> void:
	mod_dir_path = ModLoaderMod.get_unpacked_dir().plus_file(RobocrafterLP_Trade_DIR)
	# Add extensions
	install_script_extensions()
	# Add translations
	add_translations()

func install_script_extensions() -> void:
	extensions_dir_path = mod_dir_path.plus_file("extensions")
	ModLoaderMod.install_script_extension(extensions_dir_path.plus_file("singletons/debug_service.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.plus_file("ui/menus/shop/coop_item_popup.gd"))

func add_translations() -> void:
	translations_dir_path = mod_dir_path.plus_file("translations")
	ModLoaderMod.add_translation(translations_dir_path.plus_file("RobocrafterLP-Trade.en.translation"))
	ModLoaderMod.add_translation(translations_dir_path.plus_file("RobocrafterLP-Trade.ru.translation"))

func _ready() -> void:
	ModLoaderLog.info("Ready!", RobocrafterLP_Trade_LOG_NAME)
