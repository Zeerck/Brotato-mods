extends ShopItem

onready var mod_custom_material_ui = load("res://mods-unpacked/RobocrafterLP-BetterDisplay/extensions/ui/hud/material_ui.png")
onready var base_custom_material_ui = load("res://items/materials/material_ui.png")

func get_ui_gold_icon() -> Resource:
	if RunData.is_dex_mode:
		return mod_custom_material_ui
	return base_custom_material_ui

func set_shop_item(p_item_data: ItemParentData, p_wave_value: int = RunData.current_wave)->void :
    .set_shop_item(p_item_data, p_wave_value)
    if !RunData.get_player_effect_bool("hp_shop", player_index):
        if RunData.is_coop_run:
            _button.set_material_icon(get_ui_gold_icon(), CoopService.get_player_color(player_index))
        else:
            _button.set_material_icon(get_ui_gold_icon(), Utils.GOLD_COLOR)