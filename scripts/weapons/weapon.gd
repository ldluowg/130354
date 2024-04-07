extends Node2D
class_name Weapon

@export var _id = ""
@export var display_name = ""
@export var image:CompressedTexture2D
@export var projectileScene : PackedScene
@export var fire_rate = 1 :
	set (val) : fire_rate = val
	get : 
		return fire_rate - powerup_modifier.fire_rate/100
@export var recoil = 10 : 
	get :
		return recoil + powerup_modifier.recoil
@export var knock_back = 0 :
	get :
		return knock_back + powerup_modifier.knock_back
@export var weapon_type:WeaponType
@export var best_match:WeaponType
@export_multiline var description:String
@export_multiline var description_bestmatch:String
var projectile:Projectile
var dual_mode = false
var best_match_ref:Weapon = null
var can_shot = true
var weapon_slot = 0
var powerup_modifier:PowerUp = PowerUp.new()

func _head_ready():
	pass

func _post_ready():
	pass
	
func _ready():
	_head_ready()
	projectile = projectileScene.instantiate() as Projectile
	projectile.from_weapon = self
	$Timer.wait_time = 1.0 / fire_rate
	_post_ready()

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	face_to(mouse_pos)

func face_to(look_position:Vector2) -> Weapon:
	look_at(look_position)
	return self
	
func gunshot():
	pass
func best_match_action(_action):
	pass

func best_match_action_alt(_action):
	pass
	
func on_timer_timeout():
	can_shot = true

func check_best_match(weap:Weapon) -> bool:
	if weap and weap.weapon_type == best_match :
		best_match_ref = weap
		print("BEST MATCH")
		return true
	return false
	
func transition_to_left():
	pass

func transition_to_right():
	pass

func reset_coldown():
	($Timer as Timer).stop()
	can_shot = true
	
func aply_powerup(pu:PowerUp):
	powerup_modifier.damage += pu.damage
	powerup_modifier.pierce += pu.pierce
	powerup_modifier.speed += pu.speed
	powerup_modifier.size += pu.size
	powerup_modifier.projectile += pu.projectile
	powerup_modifier.fire_rate -= pu.fire_rate
	powerup_modifier.recoil += pu.recoil
	powerup_modifier.knock_back += pu.knock_back
	projectile.scale = Vector2.ONE + Vector2.ONE * (powerup_modifier.size/100)

func play_sfx():
	($GunSfx as AudioStreamPlayer2D).play()

enum WeaponType {
	NONE,
	MAGNUM,
	FLAMETHROWER,
	LAZER,
	GATLING,
	GNADE,
	BLADE,
}
