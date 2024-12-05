extends Shop

func _ready()->void :
	var _item_popup = _get_item_popup(0)
	var _error_discard_weapon = _item_popup.connect(
		"weapon_discard_button_pressed", self, "on_weapon_discard_button_pressed"
	)
	var _error_discard_weaponall = _item_popup.connect(
		"weapon_discard_button_pressedall", self, "on_weapon_discard_button_pressedall"
	)

func sell_item(weapon_data:ItemData, player_index: int = 0) -> void:
	RunData.add_recycled(player_index)

	var items_container: = _get_gear_container(player_index).items_container
	items_container._elements.remove_element2(weapon_data, true)

	RunData.remove_item(weapon_data, player_index, true)
	var recycling_value = ItemService.get_recycling_value(RunData.current_wave, weapon_data.value, player_index, true)
	RunData.add_gold(recycling_value, player_index)
	RunData.update_recycling_tracking_value(weapon_data, player_index)

	var nb_coupons = RunData.get_nb_item("item_coupon", player_index)

	if nb_coupons > 0:
		var base_value = ItemService.get_recycling_value(RunData.current_wave, weapon_data.value, player_index, true, false)
		var actual_value = ItemService.get_recycling_value(RunData.current_wave, weapon_data.value, player_index, true)
		RunData.tracked_item_effects[player_index]["item_coupon"] -= (base_value - actual_value) as int

	_update_stats(player_index)
	_get_shop_items_container(player_index).update_buttons_color()
	var reroll_button = _get_reroll_button(player_index)
	reroll_button.set_color_from_currency(RunData.get_player_gold(player_index))
	
	_popup_manager.reset_focus(player_index)
	_block_background.hide()
	var player_gear_container = _get_gear_container(player_index)
	player_gear_container.set_items_data(RunData.get_player_items(player_index))
	_popup_manager._on_element_hovered(player_gear_container.items_container.get_element(0))
	

func on_weapon_discard_button_pressed(weapon_data:ItemData, count: int = 1, player_index: int = 0) -> void :
	for i in count:
		sell_item(weapon_data, player_index)
	SoundManager.play(Utils.get_rand_element(recycle_sounds), 0, 0.1, true)
		

func on_weapon_discard_button_pressedall(weapon_data:ItemData, element:InventoryElement, player_index: int = 0)->void :
	for i in element.current_number:
		sell_item(weapon_data, player_index)
	SoundManager.play(Utils.get_rand_element(recycle_sounds), 0, 0.1, true)
