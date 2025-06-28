@icon("res://addons/blankit/icons/blankit_icon.svg")
extends Node



#region Tools

var SceneLoading:BlktSceneLoading = null
@export var scene_loading_scene:PackedScene

var Modals:BlktModals = null
@export var modals_scene:PackedScene

var Saving:BlktSaving = null
@export var saving_scene:PackedScene

var TimeScale:BlktTimeScale = null
@export var time_scale_scene:PackedScene

#endregion


#region Variables

var config : BlankitConfig = preload("res://blankit/config.tres")

#endregion



#region Godot functions

func _enter_tree() -> void:
	SceneLoading = scene_loading_scene.instantiate() as BlktSceneLoading
	add_child(SceneLoading as Node)
	
	Modals = modals_scene.instantiate() as BlktModals
	add_child(Modals as Node)
	
	Saving = saving_scene.instantiate() as BlktSaving
	add_child(Saving as Node)
	
	TimeScale = time_scale_scene.instantiate() as BlktTimeScale
	add_child(TimeScale as Node)

func _ready() -> void:
	# Inform the user that Blankit has initialized
	print("Blankit (c) 2025-present Yukon Wainczak.")
	
	if config == null:
		runtime_log("Config not found! Blankit cannot function without a config. Please restart the editor to create a new one.", true)

#endregion

#region Logging functions

func runtime_log(_string:String, _error:bool = false):
	# Print an error
	if _error:
		printerr("[Blankit] ERROR: " + _string)
	# Print a log
	else:
		print("[Blankit] " + _string)

#endregion

#region Game Mode functions

func is_mode_release() -> bool:
	return config.mode == config.Mode.RELEASE


func is_mode_demo() -> bool:
	return config.mode == config.Mode.DEMO


func is_mode_showcase() -> bool:
	return config.mode == config.Mode.SHOWCASE


func is_debug() -> bool:
	return OS.is_debug_build()

#endregion
