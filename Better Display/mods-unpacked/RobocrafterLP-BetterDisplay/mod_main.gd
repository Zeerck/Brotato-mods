extends Node

const AUTHORNAME_MODNAME = "RobocrafterLP-BetterDisplay"
const AUTHORNAME_MODNAME_DIR := AUTHORNAME_MODNAME
const AUTHORNAME_MODNAME_LOG_NAME := AUTHORNAME_MODNAME + ":Main"

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""


# Extended func's
func _init() -> void:
	mod_dir_path = ModLoaderMod.get_unpacked_dir().plus_file(AUTHORNAME_MODNAME_DIR)
	# Add extensions
	install_script_extensions()
	# Add translations
	add_translations()

func _ready() -> void:
	ModLoaderLog.info("Ready!", AUTHORNAME_MODNAME_LOG_NAME)
	_config(AUTHORNAME_MODNAME, AUTHORNAME_MODNAME_LOG_NAME)


# Custom func's
func install_script_extensions() -> void:
	extensions_dir_path = mod_dir_path.plus_file("extensions")
	
	var extensions = [
		"singletons/run_data.gd",
		"singletons/item_service.gd",
		#"singletons/debug_service.gd",
		"ui/hud/ui_consumable_to_process_list.gd",
		"ui/hud/ui_upgrade_to_process_list.gd",
		"ui/menus/pages/main_menu.gd",
		"main.gd",
		"ui/menus/shop/shop.gd",
		"ui/menus/shop/coop_shop.gd",
		"ui/menus/shop/coop_shop_player_container.gd"
	]
	
	for extension in extensions:
		ModLoaderMod.install_script_extension(extensions_dir_path.plus_file(extension))

	var scenes = [
		
	]
	for scene in scenes:
		self.add_child(load("res://mods-unpacked/RobocrafterLP-BetterDisplay/" + scene).instance())

func add_translations() -> void:
	translations_dir_path = mod_dir_path.plus_file("translations")
	
	var translations = [
		"en",
		"ru"
	]
	
	for translation in translations:
		ModLoaderMod.add_translation(translations_dir_path.plus_file("RobocrafterLP-BetterDisplay.%s.translation" % translation))

func _config(mod_id: String, mod_log: String)-> void: # Defaults for Mods Options
	var data = ModLoaderStore.mod_data[mod_id]
	
	if data != null:
		var version = data.manifest.version_number
		ModLoaderLog.info("Current Version is %s." % version, mod_log)
		var config = ModLoaderConfig.get_config(mod_id, version)
	
		if config == null:
			var defaultConfig = ModLoaderConfig.get_default_config(mod_id)
			if defaultConfig != null:
				config = ModLoaderConfig.create_config(mod_id, version, defaultConfig.data)
			else:
				config = ModLoaderConfig.create_config(mod_id, version, {})
			
		if config != null and ModLoaderConfig.get_current_config_name(mod_id) != version:
			ModLoaderConfig.set_current_config(config)
			if config.is_valid():
				config.save_to_file()
				ModLoaderLog.info("Save config to : %s" % config.save_path, mod_log)
