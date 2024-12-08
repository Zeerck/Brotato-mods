extends Node

const RobocrafterLP_Trade_ID = "RobocrafterLP-Trade"
const RobocrafterLP_Trade_DIR := RobocrafterLP_Trade_ID
const RobocrafterLP_Trade_LOG_NAME := RobocrafterLP_Trade_ID + ":Main"

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""

func _init() -> void:
	mod_dir_path = ModLoaderMod.get_unpacked_dir().plus_file(RobocrafterLP_Trade_DIR)
	# Add extensions
	install_script_extensions()
	# Add translations
	add_translations()

func _ready():
	ModLoaderLog.info("Ready!", RobocrafterLP_Trade_LOG_NAME)	
	_config()

func _config()-> void: # Defaults for Mods Options
	var data = ModLoaderStore.mod_data[RobocrafterLP_Trade_ID]

	if data != null:
		var version = data.manifest.version_number
		ModLoaderLog.info("Current Version is %s." % version, RobocrafterLP_Trade_LOG_NAME)
		var config = ModLoaderConfig.get_config(RobocrafterLP_Trade_ID, version)

		if config == null:
			var defaultConfig = ModLoaderConfig.get_default_config(RobocrafterLP_Trade_ID)
			if defaultConfig != null:
				config = ModLoaderConfig.create_config(RobocrafterLP_Trade_ID, version, defaultConfig.data)
			else:
				config = ModLoaderConfig.create_config(RobocrafterLP_Trade_ID, version, {})
			
		if config != null and ModLoaderConfig.get_current_config_name(RobocrafterLP_Trade_ID) != version:
			ModLoaderConfig.set_current_config(config)
			if config.is_valid():
				config.save_to_file()
				ModLoaderLog.info("Save config to : %s" % config.save_path, RobocrafterLP_Trade_LOG_NAME)
	
	var ModsConfigInterface = get_node("/root/ModLoader/dami-ModOptions/ModsConfigInterface")

	if ModsConfigInterface != null:
		ModLoaderLog.info("Connect setting_changed", RobocrafterLP_Trade_LOG_NAME)
		ModsConfigInterface.connect("setting_changed", self, "setting_changed")
	else:
		ModLoaderLog.info("ModsConfigInterface is null", RobocrafterLP_Trade_LOG_NAME)
	
	
func setting_changed(setting_name, value, _mod_nammod_namee)->void:
	var config = ModLoaderConfig.get_current_config(RobocrafterLP_Trade_ID)

	if config != null:
		config.data[setting_name] = value;
		config.save_to_file()

func install_script_extensions() -> void:
	extensions_dir_path = mod_dir_path.plus_file("extensions")

	var extensions = [
		"singletons/debug_service.gd",
		"ui/menus/shop/coop_item_popup.gd"
	]

	# I don't think it makes much sense, but it looks cool
	for extension in extensions:
		ModLoaderMod.install_script_extension(extensions_dir_path.plus_file(extension))

func add_translations() -> void:
	translations_dir_path = mod_dir_path.plus_file("translations")

	# Or maybe this is good practice?
	var translations = [
		"en",
		"ru"
	]

	for translation in translations:
		ModLoaderMod.add_translation(translations_dir_path.plus_file("RobocrafterLP-Trade.%s.translation" % translation))
