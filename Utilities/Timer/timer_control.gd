extends Control

var _seconds = 0
var _minutes = 0
@export var _dseconds = 00
@export var _dminutes = 5

signal on_game_time_out

@onready var labelTimer = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_timer()
	set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_seconds -= delta
	if _seconds <= 0:
		if _minutes > 0:
			_minutes -= 1
			_seconds = 60

		if _minutes <= 0 && _seconds <= 0:
			set_process(false)
			on_game_time_out.emit()
			Player.getPlayer().is_alive = false
			
	var time_string = String.num_int64(_minutes)+":"+String.num_int64(_seconds)
	labelTimer.text = time_string

func reset_timer():
	_seconds = _dseconds
	_minutes = _dminutes
