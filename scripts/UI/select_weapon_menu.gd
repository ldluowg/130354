extends Node

class_name GUI_Weapon_Manager

static var _gui_weapon_manager = null
static func _get_gui_weapon_manager():
	return GUI_Weapon_Manager._gui_weapon_manager

@onready var _weapon_manager: WeaponManager = WeaponManager._get_weapon_manager()
@onready var _primary_weapon = get_node("%weap_1")
@onready var _secondary_weapon = get_node("%weap_2")
@onready var _name = get_node("%lbl_title")
@onready var _btn_get_buff = get_node("%btn_get_weap")
@onready var _item_options = preload("res://scene/UI/item_options.tscn")

var _holding_weapon:Array[Weapon]
var _current_selecting_weapon = null
var _slot = 0
var weap_to_replace = null

func _ready():
	GUI_Weapon_Manager._gui_weapon_manager = self	

func list_weapon():
	_holding_weapon = _weapon_manager.get_equip_weapon()
#	print
	if (_holding_weapon[0]):
		var _weapon_1 = _item_options.instantiate()
		_weapon_1.set_manager(self)
		_weapon_1.set_slot(1)
		_primary_weapon.add_child(_weapon_1)
		_weapon_1.set_power_up_information(_holding_weapon[0])
		
	if(_holding_weapon[1]):
		print('weap 2')
		var _weapon_2 = _item_options.instantiate() as ColorRect
		_weapon_2.set_manager(self)		
		_weapon_2.set_slot(2)
		_secondary_weapon.add_child(_weapon_2)
		_weapon_2.set_power_up_information(_holding_weapon[1])

func  _get_weapon_slot(slot):	
	_slot = slot	

func _get_replace_weapon(weapon:Weapon):
	_current_selecting_weapon = weapon
	_name.text = _current_selecting_weapon.display_name

func _on_btn_get_weap_pressed():
	get_tree().paused = false
	self.visible = false
	print(_current_selecting_weapon)
	_weapon_manager.add_weapon(_current_selecting_weapon,_slot)
#	destroy
	_primary_weapon.get_children()[0].queue_free()
	_secondary_weapon.get_children()[0].queue_free()
	enable_get_buff_button(false)

func enable_get_buff_button(val:bool):
	_btn_get_buff.visible = val
