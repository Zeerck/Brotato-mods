extends UIUpgradeToProcessList

onready var CustomLabel = load("res://mods-unpacked/RobocrafterLP-BetterDisplay/extensions/ui/hud/count_label.tscn").instance()
const better_display_dex_mode_config = "DEX_MODE"
var lv_icon

func _ready():
	var ModsConfigInterface = get_node("/root/ModLoader/dami-ModOptions/ModsConfigInterface")
	
	if ModsConfigInterface != null:
		ModsConfigInterface.connect("setting_changed", self, "on_better_display_setting_changed")

func on_better_display_setting_changed(setting_name: String, value, mod_name):
    if setting_name == better_display_dex_mode_config and _elements.size() > 0:
        updatelist(null, _elements.size())

func _get_icon()->Resource:
    if RunData.is_dex_mode:
        return load("res://mods-unpacked/RobocrafterLP-BetterDisplay/extensions/ui/hud/upgrade_icon.png")
    return lv_icon

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
    if lv_icon == null:
        lv_icon = icon
    if node == null:
        node = element_scene.instance()
        node.name = "Levelup"
        node.set_data(_get_icon(), level)
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
            node.set_data(_get_icon(), _elements.size())
        else:
            node.set_data(_get_icon(), _elements.size())
            label.text = str(_elements.size())
