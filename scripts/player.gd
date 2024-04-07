extends CharacterBody2D
class_name Player

signal on_exp_change(current_exp,max_exp)
signal on_hp_change(current_hp,max_hp)
signal on_level_up(_player_level,_exp_need_to_level_up)
signal on_player_die

@export var max_health = 10
@export var pick_up_range = 260
@export var contact_damage_coldown = 1
@export var max_velocity = 20


var is_alive = true
var _player_max_oxi = 50
var _player_oxi = 0
@export var _is_oxi_zone = false
@onready var animationTree = $AnimationTree
@onready var animationPlayer = $AnimationPlayer
@onready var animationState = animationTree.get("parameters/playback")

var current_health = 10
var _experience_point = 0
var _level = 1
var max_experience = pow(2,_level+1)
var can_be_damage = true
var _exp_need_to_level_up = 5

var recoil : Vector2 = Vector2.ZERO
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var speed_mod = 1

static var playerEntity: Player = null
static func getPlayer()->Player:
	return Player.playerEntity	

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	current_health = max_health
	var gover = GUI_Manager._get_gui_manager().get_gui_gameover() as GameoverManager
	on_player_die.connect(gover.show_gameover)
	$OxiBar.max_value  =  _player_max_oxi
	_player_oxi = _player_max_oxi
	$PickUpColision/PickUpRange.shape.radius = pick_up_range
	$TimerGroup/ContactDamage.wait_time = contact_damage_coldown
	playerEntity = self
	on_hp_change.emit(current_health,max_health)

func _physics_process(delta):
	#check level up
	if _experience_point>=_exp_need_to_level_up:
		level_up()
	#check level up
	if velocity.length() > max_velocity:
		var velocity_direction = velocity.normalized()
		velocity = velocity_direction * max_velocity
		
	$OxiBar.value  =  _player_oxi	
	# Add the gravity.
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	move_and_slide()
	var directionX = Input.get_axis("move_left", "move_right")
	var directionY = Input.get_axis("move_up","move_down")
	var direction:Vector2 = Vector2(directionX,directionY).normalized()
	velocity.x = move_toward(velocity.x , direction.x * SPEED * speed_mod, SPEED / 10)			
	velocity.y = move_toward(velocity.y , direction.y * SPEED * speed_mod, SPEED / 10)
	var _mouse_velo = (get_global_mouse_position() - Player.getPlayer().global_position).normalized()
	animationTree.set("parameters/Look/blend_position",_mouse_velo)
	animationTree.set("parameters/Move/blend_position",_mouse_velo)
	if(velocity!=Vector2.ZERO):
		animationState.travel("Move")
	else:
		animationState.travel("Look")
		
		
func pick_up_exp(exp_value):
	_exp_need_to_level_up = set_exp_cap()
	_experience_point += exp_value
	on_exp_change.emit(exp_value,_exp_need_to_level_up)
	
func level_up():
	_level += 1
	_experience_point -= _exp_need_to_level_up
	_exp_need_to_level_up = set_exp_cap()                                        
	on_level_up.emit(_level,_exp_need_to_level_up)

func set_exp_cap():
	var _exp_cap = _exp_need_to_level_up
	if _level < 20:
		_exp_cap = pow(2,_level)
	elif _level < 40:
		_exp_cap = pow(2,_level)+_level
	else:
		_exp_cap = pow(2,_level)+_level*1.5
	return _exp_cap
	
func on_pick_up_item(item):
	if  item.has_method("_on_player_pickup") :
		item._on_player_pickup(self)

func pick_up_weapon(weapon:Weapon):
	get_weapon_manager().add_weapon(weapon,2)

func take_damage(dmg):
	if !can_be_damage : return
	$SoundGroup/hurt.play()
	DamageIndicatorManager.get_damage_indicator_manager().display_player_damage(global_position,dmg)
	current_health -= dmg
	on_hp_change.emit(current_health,max_health)
	can_be_damage = false
	$TimerGroup/ContactDamage.start()
	if current_health <= 0 :
		is_alive = false
		var gover = GUI_Manager._get_gui_manager().get_gui_gameover() as GameoverManager
		gover.gameover_type = gover.GAMEOVER_TYPE.DIED
		on_player_die.emit()

func _reset_contact_dmg_coldown():
	can_be_damage = true

func get_weapon_manager()->WeaponManager:
	return $WeaponManager


func _on_oxi_timer_timeout():
	if(_is_oxi_zone):
		_player_oxi = _player_oxi + 5
	else:
		_player_oxi = _player_oxi - 1
	if _player_oxi > _player_max_oxi:
		_player_oxi = _player_max_oxi
	elif _player_oxi <=0:
		_player_oxi = 0
