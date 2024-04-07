extends Node
class_name PowerupManager
@export var powerup_scene:Array[PackedScene]
var powerup_list:Array[PowerUp] = []

var apply_pu:Array[PowerUp] = []
var weaponManager:WeaponManager = null
static var powerup_manager = null

static func _get_powerup_manager() -> PowerupManager:
	return PowerupManager.powerup_manager
	
func _ready():
	PowerupManager.powerup_manager = self
	weaponManager = WeaponManager._get_weapon_manager()
	for scene in powerup_scene :
		powerup_list.push_back(scene.instantiate() as PowerUp)

func _selected_powerup(pu_id):
	if is_instance_of(pu_id,PowerUp) :
		var selected = pu_id as PowerUp
		apply_pu.push_back(selected)		
		if weaponManager.weapon_slot_1 :
			weaponManager.weapon_slot_1.aply_powerup(selected)
		if weaponManager.weapon_slot_2 :
			weaponManager.weapon_slot_2.aply_powerup(selected)
	else :
		print("No")
		
	
func _get_all_powerup() -> Array[PowerUp]:
	return powerup_list

