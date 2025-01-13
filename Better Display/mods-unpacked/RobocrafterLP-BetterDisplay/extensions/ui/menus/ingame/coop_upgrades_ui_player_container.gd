extends CoopUpgradesUIPlayerContainer

onready var mod_coop_material_ui = load("res://mods-unpacked/RobocrafterLP-BetterDisplay/extensions/ui/hud/material_ui.png")
onready var base_coop_material_ui_child = load("res://items/materials/material_ui.png")

func get_ui_gold_icon() -> Resource:
	if RunData.is_dex_mode:
		return mod_coop_material_ui
	return base_coop_material_ui_child

func _ready()->void :
   _gold_icon.set_icon(get_ui_gold_icon(), CoopService.get_player_color(player_index))
   _reroll_button.set_material_icon(get_ui_gold_icon(), CoopService.get_player_color(player_index))

func on_better_display_setting_changed(setting_name: String, _value, _mod_name):
	if setting_name == "DEX_MODE":
		_gold_icon.set_icon(get_ui_gold_icon(), CoopService.get_player_color(player_index))
		_reroll_button.set_material_icon(get_ui_gold_icon(), CoopService.get_player_color(player_index))
