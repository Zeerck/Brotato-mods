extends CoopShopPlayerContainer

onready var mod_upper_hbox = load("res://mods-unpacked/RobocrafterLP-BetterDisplay/extensions/ui/menus/pages/upper_hbox.tscn").instance()
onready var mod_sort_popup = load("res://mods-unpacked/RobocrafterLP-BetterDisplay/extensions/ui/menus/pages/sort_popup.tscn").instance()

var _items_container: InventoryContainer
var _sort_options_button: MyMenuButton
var _sort_popup

var available_scenes: Array = ["CoopShop"]

# Class with constant's, prevents handwritten words error
class InventorySortType:
	const CANCEL = "cancel"
	const RARITY = "rarity"
	const QUANTITY = "quantity"
	const DEFAULT = "default"

func find_first_ancestor_which_is_a(type: String, start: Node = null) -> Node:
	var current  # Start with the parent node
	if start != null:
		current = start
	else:
		current = .get_parent()
	while current:
		# Check if the node is of the specified type or inherits from it
		print(current.get_class() , type)
		if current.get_class() == type:
			return current
		current = current.get_parent()  # Move up the tree
	return null  # No matching ancestor found

func find_first_ancestor(name: String = "", type: String = "") -> Node:
	var current = .get_parent()  # Start with the parent node
	while current:
		if (name != "" and current.name == name) and (type != "" and current.get_class() == type):
			return current  # Return the first ancestor matching name or type
		current = current.get_parent()  # Move up the tree
	return null  # No matching ancestor found

func is_available_scene() -> bool:
	if get_tree().get_current_scene().get_name() in available_scenes:
		return true
	
	return false

func _ready():
	if is_available_scene():
		_items_container = player_gear_container.items_container

		var upper_hbox = set_h_box()

		if upper_hbox != null:
			_sort_options_button = upper_hbox._sort_options_button
			item_popup.get_parent().add_child(mod_sort_popup)
			_sort_popup = item_popup.get_parent().get_node("SortPopup")
			_sort_popup.hide()
		
			var _err = _sort_popup.connect("sort_by", self, "_on_sort_by")
			var _err2 = _sort_options_button.connect("pressed", self, "_on_sort_options_button_pressed")

# Event func's
func _on_sort_options_button_pressed():
	if _sort_popup != null and get_pause() == null:
		_sort_popup.open(_sort_options_button)
		_sort_popup.focus()
		var shop = find_first_ancestor("Shop", "Control")
		if shop != null:
			shop.disable_shop_buttons_focus()
			shop.disable_shop_lock_buttons_focus()
			shop._stats_container.disable_focus()
			disable_buttons_focus()
			shop._block_background.show()

func disable_buttons_focus():
	for i in player_gear_container._elements.get_children():
		i.focus_mode = FOCUS_NONE

func enable_buttons_focus():
	for i in player_gear_container._elements.get_children():
		i.focus_mode = FOCUS_ALL

func get_pause():
	var mainmenu = .get_parent()
	var max_iterations = 15
	
	for i in max_iterations:
		if mainmenu != null and mainmenu.name == "MainMenu":
			return mainmenu
		elif mainmenu != null:
			mainmenu = mainmenu.get_parent()
		else:
			return null

func set_h_box():
	var old_label: Label = _items_container.get_node("Label")
	
	_items_container.remove_child(old_label)
	_items_container.add_child(mod_upper_hbox)
	
	var upper_hbox = _items_container.get_node_or_null("UpperHBox")
	
	_items_container._label = upper_hbox._label
	
	while upper_hbox.get_position_in_parent() > 0:
		_items_container.move_child(upper_hbox, upper_hbox.get_position_in_parent() - 1)
		
	return upper_hbox



func get_player_items_inventory():
	return player_gear_container.get_node("ItemsContainer")

func _reset_focus():
	_sort_popup.hide()
	player_gear_container.get_node("ItemsContainer").focus_element_index(0)
	var shop = find_first_ancestor("Shop", "Control")
	if shop != null:
		shop.enable_shop_buttons_focus()
		shop.enable_shop_lock_buttons_focus()
		shop._stats_container.enable_focus()
		enable_buttons_focus()
		shop._block_background.hide()

func _on_sort_by(type: String):
	match type:
		InventorySortType.CANCEL:
			_reset_focus()
		InventorySortType.RARITY:
			sort_by_rarity()
			_reset_focus()
		InventorySortType.QUANTITY:
			sort_by_quantity()
			_reset_focus()
		InventorySortType.DEFAULT:
			sort_by_default()
			_reset_focus()


# Sort func's
func sort_items_by_rarity_and_quantity(a, b):
	if a.tier != b.tier:
		return a.tier < b.tier
	else:
		var items = RunData.get_player_items(player_index)
		var item_quantity_a: int = 0
		var item_quantity_b: int = 0

		if a != null and items != null:
			item_quantity_a = get_item_quantity(a, items)

		if b != null and items != null:
			item_quantity_b = get_item_quantity(b, items)

		return item_quantity_a < item_quantity_b

func sort_items_by_quantity_and_rarity(a, b):
	var items = RunData.get_player_items(player_index)
	var item_quantity_a: int = 0
	var item_quantity_b: int = 0

	if a != null and items != null:
		item_quantity_a = get_item_quantity(a, items)

	if b != null and items != null:
		item_quantity_b = get_item_quantity(b, items)

	if item_quantity_a != item_quantity_b:
		return item_quantity_a < item_quantity_b
	else:
		return a.tier < b.tier

func get_item_quantity(item_to_count, items: Array) -> int:
	var item_quantity: int = 0

	for item in items:
		if item.name == item_to_count.name:
			item_quantity += 1

	return item_quantity

func sort_by_rarity():
	var items_inventory = get_player_items_inventory()
	var items = RunData.get_player_items(player_index)
	
	items.sort_custom(self, "sort_items_by_rarity_and_quantity")
	items_inventory.set_data("ITEMS", Category.ITEM, items, true, true)

func sort_by_quantity():
	var items_inventory = get_player_items_inventory()
	var items = RunData.get_player_items(player_index)
	
	items.sort_custom(self, "sort_items_by_quantity_and_rarity")
	items_inventory.set_data("ITEMS", Category.ITEM, items, true, true)

func sort_by_default():
	var items_inventory = get_player_items_inventory()
	var items = RunData.get_player_items(player_index)
	
	items_inventory.set_data("ITEMS", Category.ITEM, items, true, true)
