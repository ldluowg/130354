extends ColorRect

var _mouse_over = false
var _buff = null
var _slot = 0

@onready var _gui_manager
@onready var _power_up_manager = GUI_Manager._get_gui_manager()
@onready var _weapon_manager = GUI_Weapon_Manager._get_gui_weapon_manager()
@onready var _BG = get_node("%BG") as ColorRect

signal _selected_upgrade(upgrade)
signal _selected_weapon(slot)

func _input(event):
	if event.is_action("prim_weapon_action"):
		if _mouse_over:
			on_click(_gui_manager)
			_BG.set_color(Color.DARK_ORANGE)
		else:
			_BG.set_color(Color.LIGHT_SKY_BLUE)

func set_power_up_information(_power_up):
	if(_gui_manager == _power_up_manager):
		connect("_selected_upgrade",Callable(_gui_manager,"_get_upgrade"))
	elif(_gui_manager == _weapon_manager):
		connect("_selected_weapon",Callable(_gui_manager,"_get_weapon_slot"))
		scale = Vector2(2,2)
	_buff = _power_up
	set_gui_when_start()

func set_gui_when_selected():
	pass

func set_gui_when_start():
	print("_buff.image: ",_buff.image)
	$BG/TextureRect.set_texture(_buff.image)

func on_click(manager):	
	if(manager == _power_up_manager):
		buff()
	elif(manager == _weapon_manager):
		weapon()

func buff():
	emit_signal("_selected_upgrade",_buff)
	set_gui_when_selected()
	_gui_manager.enable_get_buff_button(true)
	
func weapon():
	emit_signal("_selected_weapon",_slot)
	set_gui_when_selected()
	_gui_manager.enable_get_buff_button(true)
	
func set_manager(manager):
	_gui_manager = manager

func set_slot(slot):
	_slot = slot
	
func _on_mouse_entered():
	_mouse_over = true

func _on_mouse_exited():
	_mouse_over = false
	
