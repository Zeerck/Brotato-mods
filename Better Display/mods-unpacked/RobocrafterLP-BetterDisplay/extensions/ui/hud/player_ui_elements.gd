extends PlayerUIElements

func update_level_label()->void :
    .update_level_label()
    level_label.text = "XP." + str(int(RunData.get_player_xp(player_index))) + "/" + str(int(RunData.get_next_level_xp_needed(player_index))) + " | LV." + str(RunData.get_player_level(player_index))