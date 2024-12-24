extends CoopShopPlayerContainer

var _items_container: InventoryContainer
var _sort_options_button: MyMenuButton
var _sort_popup: SortPopup

var available_scenes: Array = ["Shop", "CoopShop", "Main"]

# Class with constant's, prevents handwritten words error
class InventorySortType:
	const CANCEL = "cancel"
	const RARITY = "rarity"
	const QUANTITY = "quantity"
	const DEFAULT = "default"

func is_available_scene() -> bool:
	if get_tree().get_current_scene().get_name() in available_scenes:
		return true
	
	return false

func _ready():
	if is_available_scene():
		_items_container = player_gear_container.items_container
		_sort_options_button = set_h_box()._sort_options_button
		item_popup.get_parent().add_child(load("res://mods-unpacked/RobocrafterLP-BetterDisplay/extensions/ui/menus/pages/sort_popup.tscn").instance())
		_sort_popup = item_popup.get_parent().get_node("SortPopup")
		_sort_popup.hide()
		
		var _err = _sort_popup.connect("sort_by", self, "_on_sort_by")
		var _err2 = _sort_options_button.connect("pressed", self, "_on_sort_options_button_pressed")

# Event func's
func _on_sort_options_button_pressed():
	if _sort_popup != null:
		_sort_popup.open(_sort_options_button)
		_sort_popup.focus()
		_popup_dim_screen.show()

func set_h_box() -> UpperHBox:
	var old_label: Label = _items_container.get_node("Label")
	
	_items_container.remove_child(old_label)
	_items_container.add_child(load("res://mods-unpacked/RobocrafterLP-BetterDisplay/extensions/ui/menus/pages/upper_hbox.tscn").instance())
	
	var upper_hbox = _items_container.get_node("UpperHBox") as UpperHBox
	
	_items_container._label = upper_hbox._label
	
	while upper_hbox.get_position_in_parent() > 0:
		_items_container.move_child(upper_hbox, upper_hbox.get_position_in_parent() - 1)
		
	return upper_hbox



func get_player_items_inventory():
	return player_gear_container.get_node("ItemsContainer")

func _cancel():
	var items_inventory = get_player_items_inventory()
	_sort_popup.hide()
	items_inventory.focus_element_index(0)
	_popup_dim_screen.hide()

func _on_sort_by(type: String):
	var items_inventory = get_player_items_inventory()
	
	match type:
		InventorySortType.CANCEL:
			_cancel()
		InventorySortType.RARITY:
			sort_by_rarity()
			_sort_popup.hide()
			items_inventory.focus_element_index(0)
		InventorySortType.QUANTITY:
			sort_by_quantity()
			_sort_popup.hide()
			items_inventory.focus_element_index(0)
		InventorySortType.DEFAULT:
			sort_by_default()
			_sort_popup.hide()
			items_inventory.focus_element_index(0)


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
