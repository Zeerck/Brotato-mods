extends UIConsumableToProcessList

onready var CustomLabel = load("res://mods-unpacked/RobocrafterLP-BetterDisplay/extensions/ui/hud/count_label.tscn").instance()

func add_element(item_data:ItemParentData)->void :
    _elements.push_back(item_data)
    updatelist(item_data)

func remove_element(item_data:ItemParentData)->void :
    _elements.erase(item_data)
    updatelist(item_data)
    if _elements.size() == 0:
        var node = get_node(item_data.my_id)
        if node:
            _remove_ui_node(node)

func updatelist(item_data:ItemParentData)->void :
    var node = get_node(item_data.my_id)
    if node == null:
        node = element_scene.instance()
        node.name = item_data.my_id
        node.set_item_data(item_data)
        var nodeSize = node.get_size()
        var label = CustomLabel.duplicate()
        label.text = str(_elements.size())
        label.rect_position = nodeSize + Vector2(20, 0)
        node.add_child(label)
        _add_ui_node(node)
    else:
        var label = node.get_node("Label")
        if label == null:
            var nodeSize = node.get_size()
            label = CustomLabel.duplicate()
            label.rect_position = nodeSize + Vector2(20, 0)
            label.text = str(_elements.size())
            node.add_child(label)
        else:
            label.text = str(_elements.size())