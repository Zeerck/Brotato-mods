# This whole script needs refactoring
extends InventoryContainer

var sort_by_rarity_button: MyMenuButton = MyMenuButton.new()
var sort_by_quantity_button: MyMenuButton = MyMenuButton.new()
var available_scenes: Array = ["Shop", "CoopShop"]

 
func is_inventory() -> bool:
	return self.name == "ItemsContainer"

func is_available_scene() -> bool:
	if get_tree().get_current_scene().get_name() in available_scenes:
		return true
	else:
		return false

func _ready():
	# TODO: Make good button with custom menu and two buttons in it
	# TODO: Make space between buttons and labels in h_box
	if is_inventory() and is_available_scene():
		set_h_box()
		
		set_sort_button(sort_by_rarity_button, "SortByRarityButton", "SORT_BY_RARITY_BUTTON")
		set_sort_button(sort_by_quantity_button, "SortByQuantityButton", "SORT_BY_QUANTITY_BUTTON")
		
	# Still remember about DRY, but whatever...
	if sort_by_rarity_button != null:
		var _err = sort_by_rarity_button.connect("pressed", self, "_on_sort_by_rarity_button_pressed")
	if sort_by_quantity_button != null:
		var _err = sort_by_quantity_button.connect("pressed", self, "_on_sort_by_quantity_button_pressed")

func _on_Elements_elements_changed():
	._on_Elements_elements_changed()
	
	if sort_by_rarity_button != null:
		set_button_visible(sort_by_rarity_button)
	if sort_by_quantity_button != null:
		set_button_visible(sort_by_quantity_button)

func set_button_visible(sort_button: MyMenuButton):
	# Here is a check for sort_button to show it
	var player_index: int = get_player_index()
	
	if player_index < 0 or player_index + 1 > RunData.get_player_count():
		return
	  
	if RunData.get_player_items(player_index).size() > 2:
		sort_button.visible = true
	else:
		sort_button.visible = false

func set_sort_button(sort_button: MyMenuButton, button_name: String, button_text: String):
	var label_and_sort_container = get_node("LabelAndSortHBoxContainer")
	var player_index = get_player_index()
	
	if player_index < 0:
		return null
	
	var font = load("res://resources/fonts/actual/base/font_22.tres")
	var offset = 100
	
	sort_button.name = button_name
	sort_button.text = button_text
	sort_button.set("custom_fonts/font", font)
	
	label_and_sort_container.add_child(sort_button)

func set_h_box():
	var new_h_box = HBoxContainer.new()
	var old_label: Label = .get_node("Label")
	
	new_h_box.name = "LabelAndSortHBoxContainer"
	
	.remove_child(old_label)
	.add_child(new_h_box)
	
	var label_and_sort_container = .get_node("LabelAndSortHBoxContainer")
	
	label_and_sort_container.add_child(old_label)
	
	_label = label_and_sort_container.get_node("Label")
	
	while label_and_sort_container.get_position_in_parent() > 0:
		.move_child(label_and_sort_container, label_and_sort_container.get_position_in_parent() - 1)

func _on_sort_by_rarity_button_pressed():
	# Do whatever you want
	var player_index = get_player_index()
	
	print("-----------Rarirty Player index: %s" % player_index)
	
func _on_sort_by_quantity_button_pressed():
	# Do whatever you want
	var player_index = get_player_index()
	
	print("-----------Quantity Player index: %s" % player_index)

# After this I understand why I can’t get a job :D
func get_player_index() -> int:
	if not RunData.is_coop_run:
		return 0
	
	var player_container = .get_parent()
	
	# - Luckily the bad days are over.
	# - The time has come for even worse days...
	while not "Shop" in str(player_container): # Dangerous thing
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
