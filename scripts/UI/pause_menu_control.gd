extends Control

@export var _game_manager:GameManager


func _ready():
	hide()
	_game_manager.connect("pause_game",_on_pause_game)


func _process(delta):
	pass
