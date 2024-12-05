extends "res://singletons/run_data.gd"

func get_nb_item_count(mainitem:ItemData, player_index:int)->int:
	var nb = 0

	for item in get_player_items(player_index):
		if ItemService.is_same_item(mainitem, item):
			nb += 1

	return nb