extends UpgradesUIPlayerContainer

onready var mod_material_ui = load("res://mods-unpacked/RobocrafterLP-BetterDisplay/extensions/ui/hud/material_ui.png")
onready var base_material_ui = load("res://items/materials/material_ui.png")

func get_ui_gold_icon() -> Resource:
	if RunData.is_dex_mode:
		return mod_material_ui
	return base_material_ui

func _ready()->void :
	_reroll_button.set_material_icon(get_ui_gold_icon(), Utils.GOLD_COLOR)

func on_better_display_setting_changed(setting_name: String, _value, _mod_name):
	if setting_name == "DEX_MODE":
		_reroll_button.set_material_icon(get_ui_gold_icon(), Utils.GOLD_COLOR)
