extends Inventory

func remove_element2(element:ItemParentData, check_for_duplicates:bool = false)->void :
	if check_for_duplicates:
		var children = get_children()
		var element_already_exists = false

		for child in children:
			if child.item != null and child.item.my_id == element.my_id:
				child.remove_from_number()
				if child.current_number > 0:
					element_already_exists = true
					

		if not element_already_exists:
			remove_element(element)
	else:
		remove_element(element)
