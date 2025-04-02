@icon("res://addons/blankit/icons/time_blankit_icon.svg")
extends Node



# This is an additive solution for seperate timescales per UI and the game.
# If you want to pause the game including UI, use Godot's timescale.

#region Variables

var time_scale:float = 1
var unpaused_time_scale: float = 1
var paused: bool = false

#endregion



#region Godot functions

func _process(_delta: float) -> void:
	# Catch it if the user sets time to be negative
	if time_scale < 0:
		BlankitRuntime.runtime_log("Time Scale cannot be lower than 0!", true)
		time_scale = 0

#endregion

#region Pausing functions

func pause() -> void:
	if not paused:
		paused = true
		unpaused_time_scale = time_scale
		time_scale = 0


func unpause() -> void:
	if paused:
		paused = false
		time_scale = unpaused_time_scale


func toggle_pause() -> void:
	if paused:
		unpause()
	else:
		pause()


func is_paused() -> bool:
	return paused

#endregion

#region Time scale functions

func get_time_scale() -> float:
	return time_scale

#endregion
