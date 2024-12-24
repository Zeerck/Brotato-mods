extends CoopShop

func get_xp_string(player: int) -> String:
	return str("XP.%s/%s | LV.%s" % [
			str(int(RunData.get_player_xp(player))),
			str(int(RunData.get_next_level_xp_needed(player))),
			str(RunData.get_player_level(player))
			]
			)

func get_ui_gold_icon() -> Resource:
	if RunData.is_dex_mode:
		return load("res://mods-unpacked/RobocrafterLP-BetterDisplay/extensions/ui/hud/material_ui.png")
	return load("res://items/materials/material_ui.png")
	
func new_xp_bar(player: int) -> UIProgressBar:
	var bar = load("res://ui/hud/ui_progress_bar.tscn").instance()
	var label = Label.new()
	label.set("custom_fonts/font", preload("res://resources/fonts/actual/base/font_26_outline.tres"))
	label.text = get_xp_string(player)
	label.align = 1
	label.valign = 1
	label.rect_size.x = 100
	label.uppercase = true
	label.margin_left = 12.0
	label.margin_top = 8.0
	label.margin_right = 308.0
	label.margin_bottom = 39.0
	label.grow_horizontal = 0
	bar.add_child(label)
	return bar

func _ready():
	var player_count = RunData.get_player_count()
	for player_index in player_count:
		var player_container = _get_coop_player_container(player_index)
		var _put
		
		_get_gold_label(player_index).get_parent().get_node("GoldIcon").set_icon(get_ui_gold_icon(), CoopService.get_player_color(player_index))
		_get_reroll_button(player_index).set_material_icon(get_ui_gold_icon(), CoopService.get_player_color(player_index))
		if player_count >= 3:
			_put = player_container.gold_label.get_parent().get_parent().get_parent()
			var bar = new_xp_bar(player_index)
			_put.add_child(bar)
			bar.update_value(int(RunData.get_player_xp(player_index)), int(RunData.get_next_level_xp_needed(player_index)))
			_put.move_child(bar, 1)
		else:
			_put = player_container.gold_label.get_parent().get_parent()
			var bar = new_xp_bar(player_index)
			_put.add_child(bar)
			bar.update_value(int(RunData.get_player_xp(player_index)), int(RunData.get_next_level_xp_needed(player_index)))
			_put.move_child(bar, player_container.gold_label.get_parent().get_index() - 1)
