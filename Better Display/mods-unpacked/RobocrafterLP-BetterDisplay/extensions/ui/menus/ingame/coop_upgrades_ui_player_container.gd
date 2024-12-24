extends CoopUpgradesUIPlayerContainer

func get_ui_gold_icon() -> Resource:
	if RunData.is_dex_mode:
		return load("res://mods-unpacked/RobocrafterLP-BetterDisplay/extensions/ui/hud/material_ui.png")
	return load("res://items/materials/material_ui.png")

func _ready()->void :
   _gold_icon.set_icon(get_ui_gold_icon(), CoopService.get_player_color(player_index))
   _reroll_button.set_material_icon(get_ui_gold_icon(), CoopService.get_player_color(player_index))

func on_better_display_setting_changed(setting_name: String, value, mod_name):
	if setting_name == "DEX_MODE":
		_gold_icon.set_icon(get_ui_gold_icon(), CoopService.get_player_color(player_index))
		_reroll_button.set_material_icon(get_ui_gold_icon(), CoopService.get_player_color(player_index))
