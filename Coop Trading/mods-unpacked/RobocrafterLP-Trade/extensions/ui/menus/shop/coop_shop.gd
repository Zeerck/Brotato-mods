extends CoopShop

const RobocrafterLP_Trade = "RobocrafterLP-Trade"
const trade_items_over_limit_config = "TRADE_ITEMS_OVER_LIMIT"

var coop_trading_config
var is_trade_items_over_limit: bool
# There I tried to do "is_trade_weapons_over_limit"
# but when the player starts with a weapon over the limit, all weapons after the limit disappear.
#----------------------------------
# So, we could "crack the code" a little and add more hands to the player's over-limit weapons
# but I don't think that would make much sense.

func _ready() -> void:
	var player_count: int = RunData .get_player_count()

	for player_index in player_count:
		var _item_popup = _get_item_popup(player_index)
		var _error_discard_weapon = _item_popup.connect(
			"weapon_trade_button_pressed_coop", self, "on_weapon_trade_button_pressed_coop"
		)
		var _error_discard_item = _item_popup.connect(
			"item_trade_button_pressed_coop", self, "on_item_trade_button_pressed_coop"
		)
		
	var ModsConfigInterface = get_node("/root/ModLoader/dami-ModOptions/ModsConfigInterface")
	ModsConfigInterface.connect("setting_changed", self, "on_config_changed") # Replace with function body.
	coop_trading_config = ModLoaderConfig.get_current_config(RobocrafterLP_Trade)

func on_config_changed(setting_name:String, value, mod_name):
	var config = ModLoaderConfig.get_current_config(RobocrafterLP_Trade)

	if setting_name == trade_items_over_limit_config:
		is_trade_items_over_limit = value
		if config != null:
			config.data[trade_items_over_limit_config] = value

func on_weapon_trade_button_pressed_coop(weapon_data: WeaponData, from_player_index: int = 0, to_player_index: int = 1) -> void:
	if !_can_weapon_be_bought(weapon_data, to_player_index):
		SoundManager.play(Utils.get_rand_element(Player.new().hurt_sounds), 0, 0.0, true)
		return
	
	process_player_weapons_inventory(weapon_data, from_player_index)
	.buy_weapon(weapon_data, to_player_index)
	
	SoundManager.play(Utils.get_rand_element(recycle_sounds), 0, 0.1, true)

func on_item_trade_button_pressed_coop(item_data: ItemData, from_player_index: int = 0, to_player_index: int = 1) -> void:
	if coop_trading_config != null and trade_items_over_limit_config in coop_trading_config.data:
		is_trade_items_over_limit = coop_trading_config.data[trade_items_over_limit_config]
	
	if !is_can_trade_item(item_data, to_player_index):
		SoundManager.play(Utils.get_rand_element(Player.new().hurt_sounds), 0, 0.0, true)
		return
	
	process_player_items_inventory(item_data, from_player_index)
	.buy_item(item_data, to_player_index)
	
	SoundManager.play(Utils.get_rand_element(recycle_sounds), 0, 0.1, true)

# Blatantly copied from the original game code.
func _can_weapon_be_bought(weapon_data: WeaponData, player_index: int)->bool:
	var min_weapon_tier = RunData.get_player_effect("min_weapon_tier", player_index)
	var max_weapon_tier = RunData.get_player_effect("max_weapon_tier", player_index)
	var no_melee_weapons = RunData.get_player_effect_bool("no_melee_weapons", player_index)
	var no_ranged_weapons = RunData.get_player_effect_bool("no_ranged_weapons", player_index)
	var no_duplicate_weapons = RunData.get_player_effect_bool("no_duplicate_weapons", player_index)
	var lock_current_weapons = RunData.get_player_effect_bool("lock_current_weapons", player_index)

	var weapon_type: = weapon_data.type
	var weapons = RunData.get_player_weapons(player_index)
	var weapon_slot_available: bool = RunData.has_weapon_slot_available(weapon_data, player_index)

	var player_has_weapon = false
	for weapon in weapons:
		if weapon.my_id == weapon_data.my_id:
			player_has_weapon = true
			break

	var player_has_weapon_family = false
	if weapon_data.weapon_id in RunData.get_unique_weapon_ids(player_index):
		player_has_weapon_family = true

	if weapon_data.tier > max_weapon_tier or weapon_data.tier < min_weapon_tier:
		return false

	if no_melee_weapons and weapon_type == WeaponType.MELEE:
		return false

	if no_ranged_weapons and weapon_type == WeaponType.RANGED:
		return false

	if lock_current_weapons and not weapon_slot_available:
		return false

	if player_has_weapon and not weapon_slot_available and weapon_data.upgrades_into != null and weapon_data.upgrades_into.tier <= max_weapon_tier:
		return true

	if no_duplicate_weapons and player_has_weapon_family:
		return false

	return weapon_slot_available

func is_can_trade_item(object_data, player_index: int) -> bool:
	if is_trade_items_over_limit:
		return true
	
	if object_data is ItemData:
		if RunData.get_remaining_max_nb_item(object_data, player_index) > 0 or RunData.get_remaining_max_nb_item(object_data, player_index) == -1:
			return true
		else:
			return false
	else:
		return false

func process_player_items_inventory(item_data: ItemData, player_index: int):
	_popup_manager.reset_focus(player_index)
	_update_stats(player_index)
	
	RunData.remove_item(item_data, player_index, false)
		
	_get_shop_items_container(player_index).reload_shop_items()
	_get_coop_player_container(player_index).on_hide_focused_inventory_popup()
	var player_gear_container = _get_gear_container(player_index)
	var player_items: Array = RunData.get_player_items(player_index)
	player_gear_container.set_items_data(player_items)
	player_gear_container.items_container.focus_element_index(0)

func process_player_weapons_inventory(weapon_data: WeaponData, player_index: int):
	_popup_manager.reset_focus(player_index)
	_update_stats(player_index)
	
	RunData.remove_weapon(weapon_data, player_index)
	
	_get_shop_items_container(player_index).reload_shop_items()
	_get_coop_player_container(player_index).on_hide_focused_inventory_popup()
	var player_gear_container = _get_gear_container(player_index)
	var player_weapons: Array = RunData.get_player_weapons(player_index)
	player_gear_container.set_weapons_data(player_weapons)
	player_gear_container.items_container.focus_element_index(0)
