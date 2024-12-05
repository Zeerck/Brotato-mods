extends ItemPopup

signal weapon_discard_button_pressedall(item_data, element_data)
signal weapon_discard_button_pressed(item_data)
signal weapon_cancel_button_pressed(item_data)

onready var Test = get_node("/root/ModLoader/RobocrafterLP-ItemSelling/Test")
#onready var CButton = Test.CButton
var _all
var _x10
var _x5
var _cbutton
var _display_element

func Is_coop() -> bool:
	return RunData.get_player_count() > 1

func _ready():
	if Is_coop():
		return
	_cbutton = _cancel_button.duplicate()
	var children = _cbutton.get_children()
	for child in children:
	  child.free()
	if not _cbutton:
		return
	var test = _discard_button.get_stylebox("normal").duplicate()
	_x10 = _cbutton.duplicate()
	_x10.text = "x10"
	_x10.name = "x10"
	_x10.connect("pressed", self, "_on_DiscardButton_pressed10")
	_x10.set_script(preload("res://ui/menus/global/my_menu_button.gd"))
	_x10.add_stylebox_override("normal", test)
	
	_x5 = _cbutton.duplicate()
	_x5.text = "x5"
	_x5.name = "x5"
	_x5.connect("pressed", self, "_on_DiscardButton_pressed5")
	_x5.set_script(preload("res://ui/menus/global/my_menu_button.gd"))
	_x5.add_stylebox_override("normal", test)
	_all = _cbutton.duplicate()
	_all.text = "All"
	_all.name = "All"
	_all.connect("pressed", self, "_on_DiscardButton_pressedall")
	_all.set_script(preload("res://ui/menus/global/my_menu_button.gd"))
	_all.add_stylebox_override("normal", test)
	var buttons = _cancel_button.get_parent()
	buttons.add_child(_x5)
	buttons.move_child(_x5, 3)
	buttons.add_child(_x10)
	buttons.move_child(_x10, 3)
	buttons.add_child(_all)
	buttons.move_child(_all, 2)

func update_discard_buttons(element: InventoryElement) -> void:
	_all.text = tr("MENU_RECYCLE") + " " + str(element.current_number) + " (+" + str(ItemService.get_recycling_value(RunData.current_wave, element.item.value, 0, element.item is WeaponData) * element.current_number) + ")"
	_x10.text = tr("MENU_RECYCLE") + " 10 (+" + str(ItemService.get_recycling_value(RunData.current_wave, element.item.value, 0, element.item is WeaponData) * 10) + ")"
	_x5.text = tr("MENU_RECYCLE") + " 5 (+" + str(ItemService.get_recycling_value(RunData.current_wave, element.item.value, 0, element.item is WeaponData) * 5) + ")"
	_discard_button.text = tr("MENU_RECYCLE") + " (+" + str(ItemService.get_recycling_value(RunData.current_wave, element.item.value, 0, element.item is WeaponData)) + ")"

	if _focused:
		_cancel_button.show()
		_combine_button.hide()
		_discard_button.show()
	else:
		_cancel_button.hide()
		_combine_button.hide()
		_discard_button.hide()
	if element.current_number == 5 and _focused:
		_x5.show()
		_x10.hide()
		_all.hide()
		_x5.set_focus_neighbour(1, _cancel_button.get_path())
		_x5.set_focus_neighbour(3, _discard_button.get_path())
		_discard_button.set_focus_neighbour(1, _x5.get_path())
		_cancel_button.set_focus_neighbour(3, _x5.get_path())
	elif element.current_number == 10 and _focused:
		_x5.show()
		_x10.show()
		_all.hide()
		_x10.set_focus_neighbour(1, _cancel_button.get_path())
		_x10.set_focus_neighbour(3, _x5.get_path())
		_x5.set_focus_neighbour(1, _x10.get_path())
		_x5.set_focus_neighbour(3, _discard_button.get_path())
		_discard_button.set_focus_neighbour(1, _x5.get_path())
		_cancel_button.set_focus_neighbour(3, _x10.get_path())
	elif element.current_number >= 10 and _focused:
		_x5.show()
		_x10.show()
		_all.show()
		_all.set_focus_neighbour(1, _cancel_button.get_path())
		_all.set_focus_neighbour(3, _x10.get_path())
		_x10.set_focus_neighbour(1, _all.get_path())
		_x10.set_focus_neighbour(3, _x5.get_path())
		_x5.set_focus_neighbour(1, _x10.get_path())
		_x5.set_focus_neighbour(3, _discard_button.get_path())
		_discard_button.set_focus_neighbour(1, _x5.get_path())
		_cancel_button.set_focus_neighbour(3, _x5.get_path())
	elif element.current_number >= 5 and _focused:
		_x5.show()
		_x10.hide()
		_all.show()
		_all.set_focus_neighbour(1, _cancel_button.get_path())
		_all.set_focus_neighbour(3, _x5.get_path())
		_x5.set_focus_neighbour(1, _all.get_path())
		_x5.set_focus_neighbour(3, _discard_button.get_path())
		_discard_button.set_focus_neighbour(1, _x5.get_path())
		_cancel_button.set_focus_neighbour(3, _all.get_path())
	elif element.current_number > 1 and _focused:
		_x5.hide()
		_x10.hide()
		_all.show()
		_all.set_focus_neighbour(1, _cancel_button.get_path())
		_all.set_focus_neighbour(3, _discard_button.get_path())
		_discard_button.set_focus_neighbour(1, _all.get_path())
		_cancel_button.set_focus_neighbour(3, _all.get_path())
	elif _focused:
		_x5.hide()
		_x10.hide()
		_all.hide()
		_discard_button.set_focus_neighbour(1, _cancel_button.get_path())
		_cancel_button.set_focus_neighbour(3, _discard_button.get_path())

	if _focused:
		_discard_button.show()
	else:
		_x5.hide()
		_x10.hide()
		_all.hide()
		_discard_button.hide()
		_combine_button.hide()

func solo_update_visible(element):
	if Is_coop():
		return

	if !element:
		return

	if element.item is WeaponData and buttons_enabled:
		_x10.hide()
		_all.hide()
		_x5.hide()
	elif element.item is ItemData and buttons_enabled and not "character" in element.item.my_id:
		_cancel_button.show()
		_combine_button.hide()
		_discard_button.show()
		
		update_discard_buttons(element)
	else:
		_combine_button.hide()
		_discard_button.hide()
		_cancel_button.hide()
		_x10.hide()
		_x5.hide()
		_all.hide()

func display_element(element: InventoryElement) -> void:
	_display_element = element
	.display_element(element)
	solo_update_visible(element)

func focus()->void :
	.focus()
	solo_update_visible(_display_element)

func hide(_player_index: = - 1)->void :
	.hide(_player_index)
	solo_update_visible(_display_element)

func _on_DiscardButton_pressed10() -> void:
	if _item_data is ItemData:
		emit_signal("weapon_discard_button_pressed", _item_data, 10, player_index)
		_update_button_visibilities()

func _on_DiscardButton_pressed5() -> void:
	if _item_data is ItemData:
		emit_signal("weapon_discard_button_pressed", _item_data, 5, player_index)
		_update_button_visibilities()

func _on_DiscardButton_pressedall() -> void:
	if _item_data is ItemData and _display_element is InventoryElement:
		emit_signal("weapon_discard_button_pressedall", _item_data, _display_element, player_index)
		_update_button_visibilities()

func _on_DiscardButton_pressed() -> void:
	if _item_data is ItemData:
		emit_signal("weapon_discard_button_pressed", _item_data, 1, player_index)
		_update_button_visibilities()
	elif _item_data is WeaponData:
		emit_signal("item_discard_button_pressed", _item_data)
		_update_button_visibilities()

func should_show_buttons(item_data: ItemParentData, focused: bool) -> bool:
	if item_data is ItemData:
		return buttons_enabled and not "character" in item_data.my_id and (not RunData.is_coop_run or focused)
	elif item_data is WeaponData:
		return .should_show_buttons(item_data, focused)
	return false

func _update_button_visibilities() -> void:
	var buttons := [_combine_button, _discard_button, _cancel_button, _all, _x10, _x5]
	if _item_data is WeaponData:
		._update_button_visibilities()
		return
	elif _item_data is ItemData:
		if _item_data == null or not should_show_buttons(_item_data, _focused):
			for button in buttons:
				if button != null:
					button.hide()
					button.focus_mode = FOCUS_NONE
			return

		for button in buttons:
			if (button != _combine_button):
				button.show()
				button.focus_mode = FOCUS_ALL if _focused else FOCUS_NONE
		
		if _display_element == null or _display_element.current_number == null:
			return
		
		solo_update_visible(_display_element)
