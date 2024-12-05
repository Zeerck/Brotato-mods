extends "res://singletons/debug_service.gd"


func _ready():
	ModLoaderMod.install_script_extension(ModLoaderMod.get_unpacked_dir().plus_file("RobocrafterLP-ItemSelling/extensions/ui/menus/shop/shop.gd"))
	ModLoaderMod.install_script_extension(ModLoaderMod.get_unpacked_dir().plus_file("RobocrafterLP-ItemSelling/extensions/ui/menus/shop/coop_shop.gd"))
