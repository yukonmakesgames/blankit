@tool
class_name BlankitEditor extends EditorPlugin



#region AUTOLOADS

const AUTOLOADS: Dictionary = {
	"Blankit": "res://addons/blankit/Blankit.tscn",
}

#endregion

#region Variables

var config : BlankitConfig = null

#endregion



#region Godot functions

func _enter_tree():
	# Add the autoloads
	for autoload in AUTOLOADS:
		add_autoload_singleton(autoload, AUTOLOADS[autoload])
	# Inform the user that Blankit has initialized
	print("Blankit v" + self.get_plugin_version() + " (c) 2025-present Yukon Wainczak.")

func _ready() -> void:
	# Check for configs
	var _fs = EditorInterface.get_resource_filesystem()
	while _fs.is_scanning():
		await get_tree().process_frame
	check_configs()
	if !_fs.is_scanning():
		_fs.scan()

func _exit_tree():
	# Remove autoloads
	for autoload in AUTOLOADS:
		remove_autoload_singleton(autoload)
	# Inform the user that Blankit has successfully unloaded
	editor_log("Successfully unloaded.")

#endregion

#region Config functions

func check_configs() -> void:
	if !ResourceLoader.exists("res://blankit/config.tres"):
		var _dir := DirAccess.open("res://")
		if !_dir.dir_exists("blankit"):
			_dir.make_dir("blankit")
		var _new_config = BlankitConfig.new()
		var _save_result = ResourceSaver.save(_new_config, "res://blankit/config.tres")
		if _save_result != OK:
			editor_log("Failed to create a new Blankit config file: ", _save_result)
		else:
			editor_log("Successfully created a new Blankit config file! Please edit the config in the blankit folder!")
	config = ResourceLoader.load("res://blankit/config.tres")

#endregion

#region Logging functions

func editor_log(_string:String, _error:bool = false):
	# Print an error
	if _error:
		printerr("[Blankit Editor] ERROR: " + _string)
	# Print a log
	else:
		print("[Blankit Editor] " + _string)

#endregion
