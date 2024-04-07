extends Control

@onready var _world = preload("res://World/world.tscn").instantiate()


func _on_back_pressed():
	UI_scene_transition.change_scene("res://scene/UI/UI_main_menu.tscn")


func _on_map_1_pressed():
	UI_scene_transition.change_scene("res://World/world.tscn")


func _on_map_2_pressed():
	UI_scene_transition.change_scene("res://World/world_water.tscn")
