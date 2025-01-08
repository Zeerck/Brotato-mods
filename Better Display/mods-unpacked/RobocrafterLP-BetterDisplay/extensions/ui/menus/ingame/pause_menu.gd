extends PauseMenu

onready var mod_sort_popup = load("res://mods-unpacked/RobocrafterLP-BetterDisplay/extensions/ui/menus/pages/sort_popup.tscn").instance()
onready var mod_upper_hbox = load("res://mods-unpacked/RobocrafterLP-BetterDisplay/extensions/ui/menus/pages/upper_hbox.tscn").instance()

# This is the third copy of the same code for sort_menu...
# We need something better that just "copying" the code.
# I need a little research of godot script

var available_scenes: Array = ["Shop", "CoopShop", "Main"]
var _sort_options_button: MyMenuButton
var _sort_popup
var items_container: InventoryContainer

class InventorySortType:
	const CANCEL = "cancel"
	const RARITY = "rarity"
	const QUANTITY = "quantity"
	const DEFAULT = "default"

# Default func's
func _ready():
	items_container = .get_node("Menus/MainMenu/MarginContainer/HBoxContainer/HBoxContainer/VBoxContainer/ItemsContainer")
	
	if is_available_scene() and items_container != null:
		var upper_hbox = set_h_box(items_container)

		if upper_hbox != null:
			_sort_options_button = upper_hbox._sort_options_button
			var parent = _main_menu.get_node("MarginContainer/HBoxContainer/HBoxContainer/VBoxContainer/ItemsContainer")
		
			if parent != null:
				parent.add_child(mod_sort_popup)
				_sort_popup = parent.get_node("SortPopup")
				_sort_popup.hide()
		
				var _err = _sort_popup.connect("sort_by", self, "_on_sort_by")
				_err = _sort_options_button.connect("pressed", self, "_on_sort_options_button_pressed")
				_sort_options_button.visible = false
#				_sort_options_button.visible = true

# Custom func's
func is_available_scene() -> bool:
	if get_tree().get_current_scene().get_name() in available_scenes:
		return true
	
	return false

func set_h_box(container):
	var upper_hbox = container.get_node("UpperHBox")
	
	if upper_hbox != null:
		return upper_hbox

	var old_label: Label = container.get_node("Label")
	
	upper_hbox = mod_upper_hbox
	container.remove_child(old_label)
	container.add_child(upper_hbox)

	container._label = upper_hbox._label

	while upper_hbox.get_position_in_parent() > 0:
		container.move_child(upper_hbox, upper_hbox.get_position_in_parent() - 1)

	return upper_hbox

# Event func's
func _on_sort_options_button_pressed():
	if _sort_popup != null:
		_sort_popup.open(_sort_options_button)
		_sort_popup.focus()

func _on_sort_by(type: String):
	match type:
		InventorySortType.CANCEL:
			_sort_popup.hide()
			items_container.focus_element_index(0)
		InventorySortType.RARITY:
			sort_by_rarity()
			_sort_popup.hide()
			items_container.focus_element_index(0)
		InventorySortType.QUANTITY:
			sort_by_quantity()
			_sort_popup.hide()
			items_container.focus_element_index(0)
		InventorySortType.DEFAULT:
			sort_by_default()
			_sort_popup.hide()
			items_container.focus_element_index(0)


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
	var items = RunData.get_player_items(_player_index)
	items.sort_custom(self, "sort_items_by_rarity_and_quantity")
	items_container.set_data("ITEMS", Category.ITEM, items, true, true)

func sort_by_quantity():
	var items = RunData.get_player_items(_player_index)
	items.sort_custom(self, "sort_items_by_quantity_and_rarity")
	items_container.set_data("ITEMS", Category.ITEM, items, true, true)

func sort_by_default():
	var items = RunData.get_player_items(_player_index)
	items_container.set_data("ITEMS", Category.ITEM, items, true, true)
