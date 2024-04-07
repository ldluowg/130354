extends Control

@export var _gui_manager:GUI_Manager

var _master_bus = AudioServer.get_bus_index("Master")

# Called when the node enters the scene tree for the first time.
func _ready():
	_gui_manager.connect("_toggle_pause", _on_game_pause)
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_game_pause(_is_pause:bool):
	if(_is_pause): 
		show()
	else:
		hide()

func _on_btn_resume_pressed():
	get_tree().paused = false
	hide()


func _on_btn_exit_pressed():
	get_tree().paused = false
	#hide()
	queue_free()
	UI_scene_transition.change_scene("res://scene/UI/UI_main_menu.tscn")


func _on_btn_mute_toggled(button_pressed):
	AudioServer.set_bus_mute(_master_bus, not AudioServer.is_bus_mute(_master_bus))
	pass
