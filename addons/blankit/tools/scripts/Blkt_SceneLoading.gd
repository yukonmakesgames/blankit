@icon("res://addons/blankit/icons/loading_blankit_icon.svg")
class_name BlktSceneLoading extends CanvasLayer



#region Variables

@export var fallback_scene_transition : PackedScene

var new_scene_path : String = ""
var loading_new_scene : bool = false

#endregion



#region Godot functions

func _enter_tree() -> void:
	layer = Blankit.config.canvas_layer_layer + 2

func _ready() -> void:
	visible = false

#endregion


func load_scene(_scene:PackedScene) -> void:
	if visible:
		return
	# Set values
	visible = true
	new_scene_path = _scene.resource_path
	loading_new_scene = false
	# Unpause if paused
	Blankit.TimeScale.unpause()
	if get_tree():
		# Remove current scene
		get_tree().current_scene.queue_free()  
		await !is_instance_valid(get_tree().current_scene)
		Blankit.runtime_log("Current scene successfully unloaded.")
		# Load the new scene
		var _err = ResourceLoader.load_threaded_request(new_scene_path)
		if _err != OK:
			Blankit.runtime_log("Failed to start loading scene: %s" % new_scene_path, true)
			return
		loading_new_scene = true
		# Pause
		await get_tree().process_frame
		# Check if finished loading
		while loading_new_scene:
			var _status = ResourceLoader.load_threaded_get_status(new_scene_path)
			if _status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				await get_tree().process_frame
			elif _status == ResourceLoader.THREAD_LOAD_LOADED:
				var _new_scene = ResourceLoader.load_threaded_get(new_scene_path)
				var _new_scene_instance = _new_scene.instantiate()
				get_tree().root.add_child(_new_scene_instance)
				get_tree().current_scene = _new_scene_instance
				loading_new_scene = false
		Blankit.runtime_log("New scene successfully loaded.")
		visible = false


func is_loading() -> bool:
	return visible
