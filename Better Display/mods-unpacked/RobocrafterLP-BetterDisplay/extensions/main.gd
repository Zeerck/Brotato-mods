extends Main

var _tardigrades: = [null, null, null, null]

func on_xp_added(current_xp: float, max_xp: float, player_index: int) -> void:
	var player_ui: PlayerUIElements = _players_ui[player_index]
	var display_xp = int(current_xp) % int(ceil(max_xp))
	player_ui.xp_bar.update_value(display_xp, int(max_xp))
	player_ui.level_label.text = "XP." + str(display_xp) + "/" + str(int(max_xp)) + " | LV." + str(RunData.get_player_level(player_index))

func _on_EntitySpawner_players_spawned(players: Array) -> void:
	._on_EntitySpawner_players_spawned(players)
	for i in _players.size():
		var player_ui: PlayerUIElements = _players_ui[i]
		var player_idx_string = str(i + 1)
		var tardigrade = _tardigrades[i]
		var left = i == 0 or i == 2
		if not tardigrade:
			tardigrade = preload("res://ui/hud/ui_gold.tscn").instance()
			tardigrade.name = str("%%UITardigradeP%s" % player_idx_string)
			tardigrade.visible = false
			tardigrade.alignment = BoxContainer.ALIGN_BEGIN if left else BoxContainer.ALIGN_END
			tardigrade.get_node("Icon").set_icon(load("res://mods-unpacked/RobocrafterLP-BetterDisplay/extensions/ui/hud/tardigrade_icon.png"))
			tardigrade.get_node("Icon").modulate = Color.white
			_tardigrades[i] = tardigrade
			player_ui.life_bar.get_parent().add_child(tardigrade)
			player_ui.life_bar.get_parent().move_child(tardigrade, player_ui.gold.get_index())


func _physics_process(_delta: float) -> void:
	._physics_process(_delta)
	for player_index in RunData.get_player_count():
		var tardigrade = _tardigrades[player_index]
		var life_bar_effects = _players[player_index].life_bar_effects()
		if tardigrade:
			tardigrade.visible = life_bar_effects.hit_protection > 0
			tardigrade.get_node("Icon").modulate = Color.white
			tardigrade.update_value(life_bar_effects.hit_protection)
			
