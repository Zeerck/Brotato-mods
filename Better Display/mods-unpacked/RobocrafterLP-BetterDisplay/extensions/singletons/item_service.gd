extends "res://singletons/item_service.gd"


func get_icon_from_consumable(consumable: ConsumableData)->Resource:
	if RunData.is_dex_mode:
		var resource = "res://mods-unpacked/RobocrafterLP-BetterDisplay/extensions/ui/hud/"
		var icon = load(resource + str(consumable.my_id).replace("consumable_", "") + ".png")
		if icon:
			return icon
	var cur_zone:Resource = ZoneService.get_zone_data(RunData.current_zone)
	return cur_zone.get_zone_consumable_sprite(consumable)
	
func get_consumable_to_drop(unit:Unit, item_chance:float)->ConsumableData:
	var consumable_to_drop = .get_consumable_to_drop(unit, item_chance)
	
	if consumable_to_drop != null:
		consumable_to_drop.icon = get_icon_from_consumable(consumable_to_drop)
	
	return consumable_to_drop
