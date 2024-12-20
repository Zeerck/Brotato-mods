extends Shop

func get_xp_string(player: int) -> String:
	return str("XP.%s/%s | LV.%s" % [
			str(int(RunData.get_player_xp(player))),
			str(int(RunData.get_next_level_xp_needed(player))),
			str(RunData.get_player_level(player))
			]
			)

func _ready():
    var bar = load("res://ui/hud/ui_progress_bar.tscn").instance()
    var label = Label.new()
    label.set("custom_fonts/font", preload("res://resources/fonts/actual/base/font_26_outline.tres"))
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