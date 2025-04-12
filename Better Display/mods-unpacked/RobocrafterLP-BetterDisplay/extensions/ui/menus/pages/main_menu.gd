extends MainMenu


# Extended func's
func set_neighbours(_a: Node, _b: Node):
	var parent_node = .get_node("MarginContainer/VBoxContainer/HBoxContainer2")
	
	if parent_node != null and parent_node.get_node_or_null("DexModeLabel") == null:
		# Declare nodes
		var new_dex_mode_label: Label = version_label.duplicate()
		var empty_space: Control = parent_node.get_node("EmptySpace").duplicate()
		
		# Set nodes data
		new_dex_mode_label.name = "DexModeLabel"
		new_dex_mode_label.text = "DEX_MODE"
		empty_space.name = "DexModeEmptySpace"
		
		add_and_move_child(new_dex_mode_label, parent_node)
		add_and_move_child(empty_space, parent_node)
	
	var dex_mode_label = parent_node.get_node_or_null("DexModeLabel")
	var dex_mode_empty_space = parent_node.get_node_or_null("DexModeEmptySpace")
	
	if dex_mode_label != null and dex_mode_empty_space != null:
		dex_mode_label.visible = RunData.is_dex_mode
		dex_mode_empty_space.visible = RunData.is_dex_mode


# Custom func's
func add_and_move_child(child, parent_node):
	# Adding new node to the parent node
	parent_node.add_child(child)
	
	# Change node order
	while child.get_index() > 0:
		parent_node.move_child(child, child.get_index() - 1)
	
