extends CanvasLayer
class_name GameoverManager

enum GAMEOVER_TYPE {
	DIED,
	SURVIVED
}

@export var gameover_type:GAMEOVER_TYPE = GAMEOVER_TYPE.SURVIVED

func show_gameover():
	visible = true
	Player.getPlayer().set_physics_process(false)
	WeaponManager._get_weapon_manager().toggle_process(false)
	PowerupManager._get_powerup_manager().set_process(false)
	if gameover_type == GAMEOVER_TYPE.SURVIVED :
		set_survived_message()
	else :
		set_died_message()
	display_result()

func display_result():
	$PlayStat/EnemySkilled.text = "Enemy skilled : " + str(Enemy.kill_count)
	var list_pu = PowerupManager._get_powerup_manager().apply_pu
	
	
func set_died_message():
	$Control/GameoverMessage.text = "YOU DIED"
	$Control/GameoverMessage.add_theme_color_override("font_color",Color(255,0,0))
	$SoundGroup/Fail.play()

func set_survived_message():
	$Control/GameoverMessage.text = "YOU SURVIVED"
	$Control/GameoverMessage.add_theme_color_override("font_color",Color(0,255,0))
	$SoundGroup/Success.play()
	
func press_retry():
	UI_scene_transition.change_scene("res://World/world.tscn")

func exit_to_menu():
	UI_scene_transition.change_scene("res://scene/UI/UI_main_menu.tscn")
