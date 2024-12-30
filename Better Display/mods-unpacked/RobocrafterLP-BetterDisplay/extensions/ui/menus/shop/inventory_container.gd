extends InventoryContainer

var available_scenes: Array = ["Shop"]
var _sort_options_button: MyMenuButton
var _sort_popup: SortPopup

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

# Default func's
func _ready():
	if not RunData.is_coop_run and is_available_scene():
		var shop = get_shop()
		if !shop:
			return
		var parent = shop.get_node("Content")
		
		_sort_options_button = set_h_box()._sort_options_button
		var _err2 = _sort_options_button.connect("pressed", self, "_on_sort_options_button_pressed")
		if get_pause():
			_sort_options_button.hide()
		# Idk why, but if you don't do this and you press "Cancel" in popup, you get crash :\
		sort_by_default()
		if parent != null:
			parent.add_child(load("res://mods-unpacked/RobocrafterLP-BetterDisplay/extensions/ui/menus/pages/sort_popup.tscn").instance())
			_sort_popup = parent.get_node("SortPopup")
			_sort_popup.hide()
		
			var _err = _sort_popup.connect("sort_by", self, "_on_sort_by")

func _on_Elements_elements_changed():
	._on_Elements_elements_changed() # Will this function still be called, like _ready() func?
	var available_scenes_for_update: Array = ["Shop", "CoopShop", "Main"]
	var upper_hbox: UpperHBox = .get_node("UpperHBox")
	
	if _sort_popup != null:
		_sort_popup.hide()
	
	if upper_hbox != null:
		var sort_options_button: MyMenuButton = upper_hbox._sort_options_button
		if get_tree().get_current_scene().get_name() in available_scenes_for_update and self.name == "ItemsContainer" and sort_options_button != null:
			if is_enough_items(self) and get_pause() == null:
				sort_options_button.visible = true
			else:
				sort_options_button.visible = false

# Custom func's
func is_available_scene() -> bool:
	if get_tree().get_current_scene().get_name() in available_scenes and self.name == "ItemsContainer":
		return true
	
	return false

func is_enough_items(items_container: InventoryContainer) -> bool:
	return items_container._elements.get_children().size() > 2

func get_shop():
	var shop = .get_parent()
	var max_iterations = 15
	
	for i in max_iterations:
		if shop != null and shop.name == "Shop":
			return shop
		elif shop != null:
			shop = shop.get_parent()
		else:
			return null

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
	
func set_h_box() -> UpperHBox:
	var old_label: Label = .get_node("Label")

	var upper_hbox = load("res://mods-unpacked/RobocrafterLP-BetterDisplay/extensions/ui/menus/pages/upper_hbox.tscn").instance()
	.remove_child(old_label)
	.add_child(upper_hbox)

	_label = upper_hbox._label

	while upper_hbox.get_position_in_parent() > 0:
		.move_child(upper_hbox, upper_hbox.get_position_in_parent() - 1)

	return upper_hbox

func disable_buttons_focus():
	for i in _elements.get_children():
		i.focus_mode = FOCUS_NONE

func enable_buttons_focus():
	for i in _elements.get_children():
		i.focus_mode = FOCUS_ALL

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

func _cancel():
	_sort_popup.hide()
	.focus_element_index(0)
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
			_cancel()
		InventorySortType.RARITY:
			sort_by_rarity()
			_sort_popup.hide()
			.focus_element_index(0)
		InventorySortType.QUANTITY:
			sort_by_quantity()
			_sort_popup.hide()
			.focus_element_index(0)
		InventorySortType.DEFAULT:
			sort_by_default()
			_sort_popup.hide()
			.focus_element_index(0)


# Sort func's
func sort_items_by_rarity_and_quantity(a, b):
	if a.tier != b.tier:
		return a.tier < b.tier
	else:
		var items = RunData.get_player_items(0)
		var item_quantity_a: int = 0
		var item_quantity_b: int = 0

		if a != null and items != null:
			item_quantity_a = get_item_quantity(a, items)

		if b != null and items != null:
			item_quantity_b = get_item_quantity(b, items)

		return item_quantity_a < item_quantity_b

func sort_items_by_quantity_and_rarity(a, b):
	var items = RunData.get_player_items(0)
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
	var player_index = get_player_index()
	if player_index >= 0:
		var items = RunData.get_player_items(player_index)

		items.sort_custom(self, "sort_items_by_rarity_and_quantity")
		.set_data("ITEMS", Category.ITEM, items, true, true)

func sort_by_quantity():
	var player_index = get_player_index()
	if player_index >= 0:
		var items = RunData.get_player_items(player_index)

		items.sort_custom(self, "sort_items_by_quantity_and_rarity")
		.set_data("ITEMS", Category.ITEM, items, true, true)

func sort_by_default():
	var player_index = get_player_index()
	if player_index >= 0:
		var items = RunData.get_player_items(player_index)
		.set_data("ITEMS", Category.ITEM, items, true, true)


func get_player_index() -> int:
	if not RunData.is_coop_run:
		return 0
	
	var player_container = .get_parent()
	
	while not "Shop" in str(player_container):
		if player_container == null:
			return -1
		
		if "Menus" in str(player_container):
			return -1
		
		player_container = player_container.get_parent()
	
	var regex = RegEx.new()
	regex.compile("\\d")
	
	var result = regex.search(player_container.name)
	
	if result:
		var player_index = int(result.get_string()) - 1
		return player_index
	
	return -1
