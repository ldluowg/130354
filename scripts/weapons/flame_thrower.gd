extends "res://scripts/weapons/weapon.gd"
class_name FlameThrower

static var is_player_default_vel_stored = false
static var default_player_max_velocity 
var is_activated = false

func _ready():
	_head_ready()
	projectile = $FlameThrowerProjectile
	projectile.from_weapon = self
	$Timer.wait_time = 1.0 / fire_rate
	_post_ready()
	($GunSfx as AudioStreamPlayer2D).finished.connect(stop_sfx)

func gunshot():
	if !is_activated :
		if !FlameThrower.is_player_default_vel_stored :
			FlameThrower.is_player_default_vel_stored = true
			FlameThrower.default_player_max_velocity = Player.getPlayer().speed_mod
			Player.getPlayer().speed_mod = 0.4
	activa_flame()
	is_activated = true

func transition_to_left():
	return
	$AnimationPlayer.play("flame_thrower_trans_left")
	
func transition_to_right():
	return
	$AnimationPlayer.play("flame_thrower_trans_right")

func activa_flame():
	$FlameThrowerProjectile.activate()
	if !$GunSfx.playing:
		play_sfx()

func de_activate_flame():
	$FlameThrowerProjectile.deactivate()
	if is_activated :
		is_activated = false
		Player.getPlayer().speed_mod = FlameThrower.default_player_max_velocity
		FlameThrower.is_player_default_vel_stored = false

func _input(event):
	if event.is_action_released("prim_weapon_action") and weapon_slot == 1 :
		de_activate_flame()
			
	if event.is_action_released("second_weapon_action") and weapon_slot == 2 :
		de_activate_flame()
	
func play_sfx():
	($GunSfx as AudioStreamPlayer2D).play()

func stop_sfx():
	if !is_activated:
		$GunSfx.stop()
