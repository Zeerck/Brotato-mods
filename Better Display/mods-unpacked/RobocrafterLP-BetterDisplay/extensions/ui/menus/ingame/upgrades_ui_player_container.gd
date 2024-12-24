extends UpgradesUIPlayerContainer
const better_display_dex_mode_config = "DEX_MODE"
func get_ui_gold_icon() -> Resource:
	if RunData.is_dex_mode:
		return load("res://mods-unpacked/RobocrafterLP-BetterDisplay/extensions/ui/hud/material_ui.png")
	return load("res://items/materials/material_ui.png")

func _ready()->void :
    _reroll_button.set_material_icon(get_ui_gold_icon(), Utils.GOLD_COLOR)

func on_better_display_setting_changed(setting_name: String, value, mod_name):
    if setting_name == better_display_dex_mode_config:
        _reroll_button.set_material_icon(get_ui_gold_icon(), Utils.GOLD_COLOR)