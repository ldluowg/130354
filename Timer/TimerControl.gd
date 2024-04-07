extends Control

var _seconds = 0
var _minutes = 0
var _dseconds = 30
var _dminutes = 12

signal time_updated(minutes: int, seconds: int)

@onready var labelTimer = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Vào ready")
	reset_timer()
	set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_seconds -= delta

	if _seconds <= 0:
		if _minutes > 0:
			_minutes -= 1
			_seconds = 60

		if _minutes == 0 && _seconds == 0:
			set_process(false)

	labelTimer.text = str(_minutes, ":", int(_seconds))
#	emit_signal("time_updated", _minutes, int(_seconds))
	
func reset_timer():
	print("Vào reset_timer")
	_seconds = _dseconds
	_minutes = _dminutes

func _on_timer_timeout():
	var time_string = String.num_int64(_minutes)+":"+String.num_int64(_seconds)
	print("Thời gian còn lại:", time_string)
	labelTimer.text = time_string
