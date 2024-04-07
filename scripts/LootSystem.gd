extends Node
class_name LootSystem 

var weaponManager:WeaponManager = null
var powerupManager:PowerupManager = null
static var lootSystem:LootSystem = null

static func _get_loot_system():
	return LootSystem.lootSystem
	
func _ready():
	weaponManager = WeaponManager._get_weapon_manager()
	powerupManager = PowerupManager._get_powerup_manager()
	LootSystem.lootSystem = self
	
func get_all_weapon()->Array[Weapon]:
	return weaponManager.weaponList

func get_all_powerup()->Array[PowerUp]:
	return powerupManager.powerup_list
