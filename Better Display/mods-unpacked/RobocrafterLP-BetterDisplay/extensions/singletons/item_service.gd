extends "res://singletons/item_service.gd"

var dex_mode = true # for not errors
func get_consumable_to_drop(unit:Unit, item_chance:float)->ConsumableData:
    var consumable_to_drop = .get_consumable_to_drop(unit, item_chance)
    if dex_mode: # here i need to be put setting check
        var icon = load("res://mods-unpacked/RobocrafterLP-BetterDisplay/extensions/ui/hud/" + str(consumable_to_drop.my_id).replace("consumable_", "") + ".png")
        if icon:
            consumable_to_drop.icon = icon
    return consumable_to_drop