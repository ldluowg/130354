extends Control



func _on_play_pressed():
	UI_scene_transition.change_scene("res://World/world.tscn")


func _on_options_pressed():
	UI_scene_transition.change_scene("res://scene/UI/UI_options_menu.tscn")


func _on_exit_pressed():
	get_tree().quit()
	
