class_name SortPopup
extends BasePopup

signal sort_by(sort_type)

var player_index: = 0 setget _set_player_index
func _set_player_index(value: int)->void :
	player_index = value

onready var _panel = $"%Buttons"
onready var _list = $"%List"
onready var _rarity_button = $"%RarityButton"
onready var _quantity_button = $"%QuantityButton"
onready var _cancel_button = $"%CancelButton"
var _focused: = false

func open(attachment: Control) -> void:
    show()
    set_pos_from(attachment, _panel)

func _input(event: InputEvent)->void :
	if is_visible_in_tree() and _focused and Utils.is_player_cancel_pressed(event, player_index):
		emit_signal("sort_by", "cancel")
		get_viewport().set_input_as_handled()

func focus()->void :
	_focused = true
	
	assert (_cancel_button.visible)
	_cancel_button.grab_focus()


func hide(_player_index: = - 1)->void :
	.hide(_player_index)
	_focused = false
	
func cancel()->void :
	if visible:
		_on_CancelButton_pressed()

func _get_popup_width_factor()->float:
	return 0.8

func _on_CancelButton_pressed()->void :
	emit_signal("sort_by", "cancel")
	_focused = false

func _on_RarityButton_pressed():
	emit_signal("sort_by", "rarity")
	_focused = false

func _on_QuantityButton_pressed():
	emit_signal("sort_by", "quantity")
	_focused = false


func _on_DefaultButton_pressed():
	emit_signal("sort_by", "default")
	_focused = false
