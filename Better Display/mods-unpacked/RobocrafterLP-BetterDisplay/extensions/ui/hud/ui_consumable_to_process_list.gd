extends UIConsumableToProcessList

onready var CustomLabel = load("res://mods-unpacked/RobocrafterLP-BetterDisplay/extensions/ui/hud/count_label.tscn").instance()

var box_elements = {}
const better_display_dex_mode_config = "DEX_MODE"

func _ready():
	var ModsConfigInterface = get_node("/root/ModLoader/dami-ModOptions/ModsConfigInterface")
	
	if ModsConfigInterface != null:
		ModsConfigInterface.connect("setting_changed", self, "on_better_display_setting_changed")

func on_better_display_setting_changed(setting_name: String, value, mod_name):
    if setting_name == better_display_dex_mode_config:
        for box in box_elements:
            updatelist(box_elements[box][0])

func _get_icon(item_data:ItemParentData, reload:bool)->Resource:
    if RunData.is_dex_mode:
        var icon = load("res://mods-unpacked/RobocrafterLP-BetterDisplay/extensions/ui/hud/" + str(item_data.my_id).replace("consumable_", "") + ".png")
        if icon:
            return icon
        else:
            return item_data.icon
    elif reload:
        var consumable_data = ItemService.get_consumable_for_tier(item_data.tier)
        if consumable_data:
            return consumable_data.icon
    return item_data.icon

func add_element(item_data:ItemParentData)->void :
    if !box_elements.has(item_data.my_id):
        box_elements[item_data.my_id] = []
    _elements.push_back(item_data)
    box_elements[item_data.my_id].push_back(item_data)
    updatelist(item_data)

func remove_element(item_data:ItemParentData)->void :
    _elements.erase(item_data)
    box_elements[item_data.my_id].erase(item_data)
    updatelist(item_data)
    if box_elements[item_data.my_id].size() == 0:
        var node = get_node(item_data.my_id)
        if node:
            _remove_ui_node(node)

func updatelist(item_data:ItemParentData)->void :
    var node = get_node(item_data.my_id)
    if node == null:
        node = element_scene.instance()
        node.name = item_data.my_id
        item_data.icon = _get_icon(item_data, false)
        node.set_item_data(item_data)
        var nodeSize = node.get_size()
        var label = CustomLabel.duplicate()
        label.text = str(box_elements[item_data.my_id].size())
        label.rect_position = nodeSize + Vector2(20, 0)
        node.add_child(label)
        _add_ui_node(node)
    else:
        var label = node.get_node("Label")
        if label == null:
            var nodeSize = node.get_size()
            label = CustomLabel.duplicate()
            label.rect_position = nodeSize + Vector2(20, 0)
            label.text = str(box_elements[item_data.my_id].size())
            item_data.icon = _get_icon(item_data, true)
            node.set_item_data(item_data)
            node.add_child(label)
        else:
            item_data.icon = _get_icon(item_data, true)
            node.set_item_data(item_data)
            label.text = str(box_elements[item_data.my_id].size())