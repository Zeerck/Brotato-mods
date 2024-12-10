extends MainMenu


# Extended func's
func _ready():
	var parent_node = .get_node("MarginContainer/VBoxContainer/HBoxContainer2")
	
	if parent_node != null:
		# Declare nodes
		var new_dex_mode_label: Label = version_label.duplicate()
		var empty_space: Control = parent_node.get_node("EmptySpace").duplicate()
		
		# Set nodes data
		new_dex_mode_label.name = "DexModeLabel"
		new_dex_mode_label.text = "DEX_MODE"
		empty_space.name = "EmptySpace2"
		
		add_and_move_child(new_dex_mode_label, parent_node, 1)
		add_and_move_child(empty_space, parent_node, 1)

func set_neighbours(a: Node, b: Node):
	var dex_mode_label: Label = get_node("MarginContainer/VBoxContainer/HBoxContainer2/DexModeLabel")
	
	if dex_mode_label != null:
		dex_mode_label.visible = RunData.is_dex_mode


# Custom func's
func add_and_move_child(child, parent_node, move_index: int = 0):
	# Adding new node to the parent node
	parent_node.add_child(child)
	
	# Change node order
	if move_index > 0:
		parent_node.move_child(child, child.get_index() - move_index)
	
