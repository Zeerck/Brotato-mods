extends Shop
const better_display_dex_mode_config = "DEX_MODE"

onready var mod_material_ui = load("res://mods-unpacked/RobocrafterLP-BetterDisplay/extensions/ui/hud/material_ui.png")
onready var base_material_ui = load("res://items/materials/material_ui.png")
onready var base_ui_progress_bar = load("res://ui/hud/ui_progress_bar.tscn").instance()
onready var base_font_26_outline = preload("res://resources/fonts/actual/base/font_26_outline.tres")

func get_xp_string(player: int) -> String:
	return str("XP.%s/%s | LV.%s" % [
			str(int(RunData.get_player_xp(player))),
			str(int(RunData.get_next_level_xp_needed(player))),
			str(RunData.get_player_level(player))
			]
			)

func get_ui_gold_icon() -> Resource:
	if RunData.is_dex_mode:
		return mod_material_ui
	return base_material_ui

func _ready():
	# var ModsConfigInterface = get_node("/root/ModLoader/dami-ModOptions/ModsConfigInterface")
	
	# if ModsConfigInterface != null:
	#     ModsConfigInterface.connect("setting_changed", self, "on_better_display_setting_changed")
	
	var bar = base_ui_progress_bar
	var label = Label.new()
	label.set("custom_fonts/font", base_font_26_outline)
	label.text = get_xp_string(0)
	label.align = 1
	label.valign = 1
	label.uppercase = true
	label.margin_left = 12.0
	label.margin_top = 8.0
	label.margin_right = 308.0
	label.margin_bottom = 39.0
	label.grow_horizontal = 0
	bar.add_child(label)
	bar.update_value(int(RunData.get_player_xp(0)), int(RunData.get_next_level_xp_needed(0)))
	_title.get_parent().add_child(bar)
	_title.get_parent().move_child(bar, _title.get_index() + 1)
	_get_gold_label(0).get_parent().get_node("GoldIcon").set_icon(get_ui_gold_icon(), Utils.GOLD_COLOR)
	_get_reroll_button(0).set_material_icon(get_ui_gold_icon(), Utils.GOLD_COLOR)

# func on_better_display_setting_changed(setting_name: String, _value, _mod_name):
#     if setting_name == better_display_dex_mode_config:
#         _reroll_button.set_material_icon(get_ui_gold_icon(), Utils.GOLD_COLOR)
