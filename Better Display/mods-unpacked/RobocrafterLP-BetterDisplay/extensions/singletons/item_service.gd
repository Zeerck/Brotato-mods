extends "res://singletons/item_service.gd"


func get_consumable_to_drop(unit:Unit, item_chance:float)->ConsumableData:
	var consumable_to_drop = .get_consumable_to_drop(unit, item_chance)
	
	if RunData.is_dex_mode and consumable_to_drop != null:
		var resource = "res://mods-unpacked/RobocrafterLP-BetterDisplay/extensions/ui/hud/"
		var icon = load(resource + str(consumable_to_drop.my_id).replace("consumable_", "") + ".png")
		
		if icon:
			consumable_to_drop.icon = icon
	
	return consumable_to_drop
