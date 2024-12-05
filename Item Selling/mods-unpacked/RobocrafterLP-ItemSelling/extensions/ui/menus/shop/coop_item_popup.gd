extends CoopItemPopup

signal weapon_discard_button_pressedall_coop(item_data, element_data)
signal weapon_discard_button_pressed_coop(item_data)

#onready var CButton = Test.CButton
var _allcoop
var _x10coop 
var _x5coop
var _cbuttoncoop
var _display_element_coop

func Is_coop() -> bool:
	return RunData.get_player_count() > 1

func _ready():
	if not Is_coop():
		return
	_cbuttoncoop = _cancel_button.duplicate()
	var children = _cbuttoncoop.get_children()
	for child in children:
	  child.free()

	if not _cbuttoncoop:
		return
	var test = _discard_button.get_stylebox("normal").duplicate()
	_x10coop = _cbuttoncoop.duplicate()
	_x10coop.text = "x10"
	_x10coop.name = "x10"
	_x10coop.connect("pressed",self,"_on_DiscardButton_pressed10_coop")
	_x10coop.set_script(preload("res://ui/menus/global/my_menu_button.gd"))
	_x10coop.add_stylebox_override("normal",test)
	_x10coop.hide()
	
	_x5coop = _cbuttoncoop.duplicate()
	_x5coop.text = "x5"
	_x5coop.name = "x5"
	_x5coop.connect("pressed",self,"_on_DiscardButton_pressed5_coop")
	_x5coop.set_script(preload("res://ui/menus/global/my_menu_button.gd"))
	_x5coop.add_stylebox_override("normal",test)
	_x5coop.hide()
	
	_allcoop = _cbuttoncoop.duplicate()
	_allcoop.text = "All"
	_allcoop.name = "All"
	_allcoop.connect("pressed",self,"_on_DiscardButton_pressedall_coop")
	_allcoop.set_script(preload("res://ui/menus/global/my_menu_button.gd"))
	_allcoop.add_stylebox_override("normal",test)
	_allcoop.hide()
	var buttons = _cancel_button.get_parent()
	buttons.add_child(_x5coop)
	buttons.move_child(_x5coop, 3)
	buttons.add_child(_x10coop)
	buttons.move_child(_x10coop, 3)
	buttons.add_child(_allcoop)
	buttons.move_child(_allcoop, 2)

func update_discard_buttons(element:InventoryElement)->void:
	if !element:
		return

	_allcoop.text = tr("MENU_RECYCLE") + " " + str(element.current_number) + " (+" + str(ItemService.get_recycling_value(RunData.current_wave, element.item.value, 0, element.item is WeaponData) * element.current_number) + ")"
	_x10coop.text = tr("MENU_RECYCLE") + " 10 (+" + str(ItemService.get_recycling_value(RunData.current_wave, element.item.value, 0, element.item is WeaponData) * 10) + ")"
	_x5coop.text = tr("MENU_RECYCLE") + " 5 (+" + str(ItemService.get_recycling_value(RunData.current_wave, element.item.value, 0, element.item is WeaponData) * 5) + ")"
	_discard_button.text = tr("MENU_RECYCLE") + " (+" + str(ItemService.get_recycling_value(RunData.current_wave, element.item.value, 0, element.item is WeaponData)) + ")"

	if _focused:
		print("default")
		_combine_button.hide()
		_discard_button.show()
		_cancel_button.show()
	elif not _focused:
		_cancel_button.hide()
		_combine_button.hide()
		_discard_button.hide()

	if element.current_number == 5 and _focused:
		_x5coop.show()
		_x10coop.hide()
		_allcoop.hide()
		_x5coop.set_focus_neighbour(1, _cancel_button.get_path())
		_x5coop.set_focus_neighbour(3, _discard_button.get_path())
		_discard_button.set_focus_neighbour(1, _x5coop.get_path())
		_cancel_button.set_focus_neighbour(3, _x5coop.get_path())
	elif element.current_number == 10 and _focused:
		_x5coop.show()
		_x10coop.show()
		_allcoop.hide()
		_x10coop.set_focus_neighbour(1, _cancel_button.get_path())
		_x10coop.set_focus_neighbour(3, _x5coop.get_path())
		_x5coop.set_focus_neighbour(1, _x10coop.get_path())
		_x5coop.set_focus_neighbour(3, _discard_button.get_path())
		_discard_button.set_focus_neighbour(1, _x5coop.get_path())
		_cancel_button.set_focus_neighbour(3, _x10coop.get_path())
	elif element.current_number >= 10 and _focused:
		_x5coop.show()
		_x10coop.show()
		_allcoop.show()
		_allcoop.set_focus_neighbour(1, _cancel_button.get_path())
		_allcoop.set_focus_neighbour(3, _x10coop.get_path())
		_x10coop.set_focus_neighbour(1, _allcoop.get_path())
		_x10coop.set_focus_neighbour(3, _x5coop.get_path())
		_x5coop.set_focus_neighbour(1, _x10coop.get_path())
		_x5coop.set_focus_neighbour(3, _discard_button.get_path())
		_discard_button.set_focus_neighbour(1, _x5coop.get_path())
		_cancel_button.set_focus_neighbour(3, _x5coop.get_path())
	elif element.current_number >= 5 and _focused:
		_x5coop.show()
		_x10coop.hide()
		_allcoop.show()
		_allcoop.set_focus_neighbour(1, _cancel_button.get_path())
		_allcoop.set_focus_neighbour(3, _x5coop.get_path())
		_x5coop.set_focus_neighbour(1, _allcoop.get_path())
		_x5coop.set_focus_neighbour(3, _discard_button.get_path())
		_discard_button.set_focus_neighbour(1, _x5coop.get_path())
		_cancel_button.set_focus_neighbour(3, _allcoop.get_path())
	elif element.current_number > 1 and _focused:
		_x5coop.hide()
		_x10coop.hide()
		_allcoop.show()
		_allcoop.set_focus_neighbour(1, _cancel_button.get_path())
		_allcoop.set_focus_neighbour(3, _discard_button.get_path())
		_discard_button.set_focus_neighbour(1, _allcoop.get_path())
		_cancel_button.set_focus_neighbour(3, _allcoop.get_path())
	elif _focused:
		_x5coop.hide()
		_x10coop.hide()
		_allcoop.hide()
		_discard_button.set_focus_neighbour(1, _cancel_button.get_path())
		_cancel_button.set_focus_neighbour(3, _discard_button.get_path())

func coop_update_visible(element):
	if not Is_coop():
		return

	if !element:
		return

	if element.item is WeaponData and buttons_enabled:
		_x10coop.hide()
		_allcoop.hide()
		_x5coop.hide()
	elif element.item is ItemData and buttons_enabled and not "character" in element.item.my_id:
		update_discard_buttons(element)
	else:
		_combine_button.hide()
		_discard_button.hide()
		_cancel_button.hide()
		_x10coop.hide()
		_x5coop.hide()
		_allcoop.hide()
	#show()

func display_element(element:InventoryElement)->void :
	_display_element_coop = element
	.display_element(element)
	coop_update_visible(element)

func focus()->void :
	.focus()
	coop_update_visible(_display_element_coop)

func hide(_player_index: = - 1)->void :
	.hide(_player_index)
	coop_update_visible(_display_element_coop)

func _on_DiscardButton_pressed10_coop()->void :
	if _item_data is ItemData:
		emit_signal("weapon_discard_button_pressed", _item_data, 10, player_index)
		_update_button_visibilities()

func _on_DiscardButton_pressed5_coop()->void :
	if _item_data is ItemData:
		emit_signal("weapon_discard_button_pressed", _item_data, 5, player_index)
		_update_button_visibilities()

func _on_DiscardButton_pressedall_coop()->void :
	if _item_data is ItemData and _display_element_coop is InventoryElement:
		emit_signal("weapon_discard_button_pressedall", _item_data, _display_element_coop, player_index)
		_update_button_visibilities()

func _on_DiscardButton_pressed()->void :
	if _item_data is ItemData:
		emit_signal("weapon_discard_button_pressed", _item_data, 1, player_index)
		_update_button_visibilities()
	elif _item_data is WeaponData:
		emit_signal("item_discard_button_pressed", _item_data)
		_update_button_visibilities()

func should_show_buttons(item_data:ItemParentData, focused:bool)->bool:
	if item_data is ItemData:
		return buttons_enabled and not "character" in item_data.my_id and ( not RunData.is_coop_run or focused)
	elif item_data is WeaponData:
		return .should_show_buttons(item_data, focused)
	return false

func _update_button_visibilities()->void :
	var buttons: = [_combine_button, _discard_button, _cancel_button, _allcoop, _x10coop, _x5coop]

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

		if _display_element_coop == null or _display_element_coop.current_number == null: 
			return
		
		coop_update_visible(_display_element_coop)

		print("_cancel_button: ", _cancel_button.visible)
		print("_discard_button: ", _discard_button.visible)
		print("_combine_button: ", _combine_button.visible)
