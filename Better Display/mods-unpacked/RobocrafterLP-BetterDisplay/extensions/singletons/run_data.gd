extends "res://singletons/run_data.gd"

const RobocrafterLP_BetterDisplay = "RobocrafterLP-BetterDisplay"
const better_display_dex_mode_config = "DEX_MODE"

var better_display_config: ModConfig
var is_dex_mode: bool = true


# Extended func's
func _ready():
	var ModsConfigInterface = get_node("/root/ModLoader/dami-ModOptions/ModsConfigInterface")
	
	if ModsConfigInterface != null:
		ModsConfigInterface.connect("setting_changed", self, "on_better_display_setting_changed")
		better_display_config = ModLoaderConfig.get_current_config(RobocrafterLP_BetterDisplay)
	
	if better_display_config != null and better_display_dex_mode_config in better_display_config.data:
		better_display_config.data[better_display_dex_mode_config] = true
		is_dex_mode = better_display_config.data[better_display_dex_mode_config]


# Custom func's
func on_better_display_setting_changed(setting_name: String, value, mod_name): # Yes, func is called that because some conflicts happen here
	var config = ModLoaderConfig.get_current_config(RobocrafterLP_BetterDisplay)

	if setting_name == better_display_dex_mode_config:
		is_dex_mode = value
		if config != null:
			config.data[better_display_dex_mode_config] = value
