extends UIUpgradeToProcessList

onready var CustomLabel = load("res://mods-unpacked/RobocrafterLP-BetterDisplay/extensions/ui/hud/count_label.tscn").instance()

var dex_mode = false # for not errors
func add_element(icon:Resource, level:int)->void :
    _elements.push_back(level)
    updatelist(icon, level)

func remove_element(level:int)->void :
    _elements.erase(level)
    updatelist(null, level)
    if _elements.size() == 0:
        var node = get_node("Levelup")
        if node:
            _remove_ui_node(node)

func updatelist(icon:Resource, level:int)->void :
    var node = get_node("Levelup")
    if node == null:
        node = element_scene.instance()
        node.name = "Levelup"
        if dex_mode: # here i need to be put setting check
            icon = load("res://mods-unpacked/RobocrafterLP-BetterDisplay/extensions/ui/hud/upgrade_icon.png")
        node.set_data(icon, level)
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