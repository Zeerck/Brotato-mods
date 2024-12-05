extends InventoryElement

func remove_from_number(value:int = 1)->int :
	current_number -= value
	_number_label.text = "x" + str(current_number)
	
	if current_number == 1:
		_number_label.hide()
	return current_number
