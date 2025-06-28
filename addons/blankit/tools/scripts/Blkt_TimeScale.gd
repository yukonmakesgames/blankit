@icon("res://addons/blankit/icons/time_blankit_icon.svg")
class_name BlktTimeScale extends Node



# This is an additive solution for seperate timescales per UI and the game.
# If you want to pause the game including UI, use Godot's timescale.

#region Variables

var time_scale:float = 1
var cached_unpaused_time_scale: float = 1
var cached_object_time_scale: float = 1
var paused: bool = false
var can_pause: bool = true

var objects_stopping_time:Array = []

#endregion



#region Godot functions

func _process(_delta: float) -> void:
	# Catch it if the user sets time to be negative
	if time_scale < 0:
		Blankit.runtime_log("Time Scale cannot be lower than 0!", true)
		time_scale = 0
	# Remove null entries from objects stopping time
	if objects_stopping_time.has(null):
		objects_stopping_time.erase(null)
		check_if_object_is_stopping_time()

#endregion

#region Pausing functions

func pause() -> void:
	if not paused and can_pause:
		paused = true
		cached_unpaused_time_scale = time_scale
		time_scale = 0


func unpause() -> void:
	if paused:
		paused = false
		time_scale = cached_unpaused_time_scale


func toggle_pause() -> void:
	if paused:
		unpause()
	else:
		pause()


func is_paused() -> bool:
	return paused

#endregion

#region Object stopping time functions

func add_object_stopping_time(_object) -> void:
	if not objects_stopping_time.has(_object):
		objects_stopping_time.append(_object)
		check_if_object_is_stopping_time()


func remove_object_stopping_time(_object) -> void:
	if objects_stopping_time.has(_object):
		objects_stopping_time.erase(_object)
		check_if_object_is_stopping_time()


func check_if_object_is_stopping_time() -> void:
	if objects_stopping_time.size() > 0:
		if time_scale > 0:
			can_pause = false
			paused = false
			cached_object_time_scale = time_scale
			time_scale = 0
	elif cached_object_time_scale != 0:
		can_pause = true
		time_scale = cached_object_time_scale
		cached_object_time_scale = 0

#endregion

#region Time scale functions

func get_time_scale() -> float:
	return time_scale

#endregion
