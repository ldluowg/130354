extends Node2D
class_name WeaponManager

@export var weaponSceneList:Array[PackedScene]
var weaponList:Array[Weapon] = []
var weapon_slot_1:Weapon = null
var weapon_slot_2:Weapon = null
var isBestMatch = false

static var weapon_manager = null
static func _get_weapon_manager() -> WeaponManager: return WeaponManager.weapon_manager
# Called when the node enters the scene tree for the first time.
func _ready():
	for scene in weaponSceneList:
		weaponList.push_back( scene.instantiate() as Weapon )
	WeaponManager.weapon_manager = self
	weapon_slot_1 = preload("res://prefabs/weapon/magnum.tscn").instantiate()
	weapon_slot_1.weapon_slot = 1
	add_child(weapon_slot_1)
	
	weapon_slot_2 = preload("res://prefabs/weapon/magnum.tscn").instantiate()
	weapon_slot_2.weapon_slot = 2
	add_child(weapon_slot_2)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var shot_slot_1 = Input.is_action_pressed("prim_weapon_action")
	var shot_slot_2 = Input.is_action_pressed("second_weapon_action")
	var mouse_pos = get_global_mouse_position()
	if isBestMatch :
		update_weapon_bestmatch(shot_slot_1,shot_slot_2)
	if weapon_slot_1 : update_weapon(weapon_slot_1,shot_slot_1,mouse_pos)
	if weapon_slot_2 : update_weapon(weapon_slot_2,shot_slot_2,mouse_pos)
	
func update_weapon(weap:Weapon,shot,mouse_pos):
	if shot :
		var did_shot = weap.gunshot()
		if did_shot :
			var player:Player = get_parent()
			var recoil_direction:Vector2 = mouse_pos - player.position
			player.velocity -= recoil_direction.normalized() * weap.recoil * 100

func update_weapon_bestmatch(prim_action,secnd_action):
	return
	weapon_slot_1.best_match_action(prim_action)
	weapon_slot_1.best_match_action_alt(secnd_action)
	

func add_weapon(weap:Weapon,slot):
	var weaponChanged = try_add_weapon(weap,slot)
	if weaponChanged :
		call_deferred("add_child",weaponChanged)
		isBestMatch = check_best_match()
#		change_mode()
		try_reset_coldown()

func try_add_weapon(weap:Weapon,slot)->Weapon:
	if slot == 1 :
		if !weapon_slot_1 :
			weapon_slot_1 = weap
			weapon_slot_1.weapon_slot = 1
			return weapon_slot_1
		if weapon_slot_1.weapon_type != weap.weapon_type:
			weapon_slot_1.free()
			weapon_slot_1 = weap
			weapon_slot_1.weapon_slot = 1			
			return weapon_slot_1
	if slot == 2 :
		if !weapon_slot_2:
			weapon_slot_2 = weap
			weapon_slot_2.weapon_slot = 2
			return weapon_slot_2
		if weapon_slot_2.weapon_type != weap.weapon_type:	
			weapon_slot_2.free()
			weapon_slot_2 = weap
			weapon_slot_2.weapon_slot = 2
			return weapon_slot_2
	return null
	
func check_best_match():
	if weapon_slot_1 :
		return weapon_slot_1.check_best_match(weapon_slot_2)
	return false

func change_mode():
	if !weapon_slot_1 or !weapon_slot_2 :
		return false
	weapon_slot_1.transition_to_left()
	weapon_slot_2.transition_to_right()
	weapon_slot_2.dual_mode = true
	weapon_slot_1.dual_mode = true

func try_reset_coldown():
	if weapon_slot_1 : weapon_slot_1.reset_coldown()
	if weapon_slot_2 : weapon_slot_2.reset_coldown()
	
func get_list_weapon()->Array[Weapon]:
	return weaponList
	
func get_equip_weapon()->Array[Weapon]:
	return [weapon_slot_1,weapon_slot_2]
	
func get_weapon(weapon)->Weapon:
	var index = weaponList.filter( func(weap:Weapon): 
		return weap.weapon_type == weapon )
	if index.size() > 0 : return index[0]
	return null

func toggle_process(val:bool):
	set_process(val)
	if weapon_slot_1 : weapon_slot_1.set_process(val)
	if weapon_slot_2 : weapon_slot_2.set_process(val)
