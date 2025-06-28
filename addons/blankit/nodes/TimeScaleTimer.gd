@icon("res://addons/blankit/icons/timer_blankit_icon.svg")
class_name TimeScaleTimer extends Node



#region Variables

@export_range(0.001, 4096, 0.001) var wait_time: float = 5.0
@export var one_shot: bool = true
@export var autostart: bool = false

var time_left: float = 0.0
var stopped: bool = true

#endregion

#region Signals

signal timeout

#endregion



#region Godot functions

func _ready():
	if autostart:
		start()


func _process(_delta):
	if not stopped:
		_delta *= Blankit.TimeScale.get_time_scale()
		time_left -= _delta
		if time_left <= 0:
			stopped = true
			time_left = 0
			emit_signal("timeout")
			if not one_shot:
				start()

#endregion

#region Timer functions

# Start the timer
func start(_time_sec = null):
	if _time_sec != null:
		wait_time = _time_sec
	time_left = wait_time
	stopped = false


# Stop the timer
func stop():
	stopped = true


# Check if the timer is stopped
func is_stopped() -> bool:
	return stopped

#endregion
