extends Node2D

class_name GUI_Manager

static var _gui_manager = null
static func _get_gui_manager()->GUI_Manager:
	return GUI_Manager._gui_manager
	
signal _upgrade_player(upgrade)
signal _replace_weapon(weapon)
signal _toggle_pause(_is_paused:bool)
	
#GUI
@onready var _buff_manager:PowerupManager = PowerupManager._get_powerup_manager()
@onready var _gui_weapon_manager:GUI_Weapon_Manager = GUI_Weapon_Manager._get_gui_weapon_manager()
@onready var _exp_bar = get_node("%exp_bar")
@onready var _hp_bar = get_node("%hp_bar")
@onready var _lbl_hp = get_node("%lbl_hp")
@onready var _lbl_level = get_node("%lbl_level")
@onready var _level_panel = get_node("%pnl_level_up")
@onready var _upgrade_options = get_node("%upgrade_option")
@onready var _levelup_sound = get_node("%snd_lvl_up")
@onready var _buff_des_1 = get_node("%lbl_buff_des1")
@onready var _buff_des_2 = get_node("%lbl_buff_des2")
@onready var _buff_name = get_node("%lbl_buff_name")
@onready var _btn_get_buff = get_node("%btn_get_buff")
@onready var _select_weapon_menu = get_node("GUI_select_weapon_to_replace/select_weapon_menu")
@onready var _item_options = preload("res://scene/UI/item_options.tscn")

var _all_buff_possible_to_pick:Array[PowerUp] = []
var _current_selecting_buff = null
		
func _ready():
	GUI_Manager._gui_manager = self
	_all_buff_possible_to_pick = _buff_manager._get_all_powerup()
	connect("_upgrade_player",Callable(_buff_manager,"_selected_powerup"))
	connect("_replace_weapon",Callable(_gui_weapon_manager,"_get_replace_weapon"))
	_exp_bar.value = 0
	

func _display_exp (current,max):
	_exp_bar.value = current/max * 100

func _input(event):
	if(event.is_action_pressed("ui_cancel")):
		get_tree().paused = true
		emit_signal("_toggle_pause",get_tree().paused)
		
func _on_player_level_up(_level:int,_exp_need_to_level_up:int):
	_levelup_sound.play()
	_lbl_level.text = str("Level: ",_level)
	var tween = _level_panel.create_tween()
	tween.tween_property(_level_panel,"position",Vector2(180,100),0.4).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	_level_panel.visible = true	
	get_tree().paused = true
	#spawn option
	var _number_of_option = 0
	var _max_number_option = 4
	
	#get buff
	_all_buff_possible_to_pick.shuffle()
	var random_powerup = [
		_all_buff_possible_to_pick[0],
		_all_buff_possible_to_pick[1],
		_all_buff_possible_to_pick[2]
	]
	WeaponManager._get_weapon_manager().get_list_weapon().shuffle()
	var random_weapon = WeaponManager._get_weapon_manager().get_list_weapon()[0]
	
	#get buff
	while _number_of_option < _max_number_option:
		var _buff_option = _item_options.instantiate()
		_buff_option.set_manager(self)
		_upgrade_options.add_child(_buff_option)
		if _number_of_option < 3:
			_buff_option.set_power_up_information(random_powerup[_number_of_option])
		else:
			_buff_option.set_power_up_information(random_weapon)
		_number_of_option += 1
	#spawn option		
	_exp_bar.value = 0



func _on_player_hp_change(current_hp, max_hp):
	current_hp += 0.0
	_hp_bar.value = (current_hp/max_hp) * 100 
	(_hp_bar.get_child(0) as Label).text = "HP: "+ str(current_hp) +"/"+ str(max_hp) 



func _on_player_die():
	pass # Replace with function body.



func _on_player_exp_change(current_exp, max_exp):
	_exp_bar.value = Player.getPlayer()._experience_point/max_exp*100
	
	
func _on_get_buff_pressed():
#	transfer buff to upgrade player
	if (_current_selecting_buff is PowerUp):
		emit_signal("_upgrade_player",_current_selecting_buff)
		get_tree().paused = false
	elif(_current_selecting_buff is Weapon):
		emit_signal("_replace_weapon",_current_selecting_buff)
		_select_weapon_menu.visible = true
		_select_weapon_menu.list_weapon()
		
	else:
		pass
		
	_current_selecting_buff = null
#	turn off lvl up panel 
	var _buffs = _upgrade_options.get_children()
	for i in _buffs:
		i.queue_free()
	_level_panel.visible = false
	enable_get_buff_button(false)
	_level_panel.position = Vector2(2000,100)


func  _get_upgrade(_buff):
	_current_selecting_buff=_buff
	_buff_name.text = _buff.display_name
	_buff_des_1.text = _buff.description


func enable_get_buff_button(val:bool):
	_btn_get_buff.visible = val

func get_gui_gameover():
	return $GUI_gameover
