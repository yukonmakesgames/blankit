@icon("res://addons/blankit/icons/save_blankit_icon.svg")
extends Node



#region Variables

const FILE_EXTENSION:String = ".json"

var profile:String = "default"
var data:Dictionary = {}

@onready var game_index = BlankitRuntime.get_config_value("core", "game_index", "blankit")
@onready var save_version = BlankitRuntime.get_config_value("saving", "save_file_version", 1)

#endregion



#region Profile functions

# Allows you to set what profile to save to
func set_profile(_value:String) -> void:
	profile = _value

#endregion

#region Utility functions

func get_save_path(_filename:String, _shared: bool) -> String:
	# Set the base path
	var _path = "user://saves/"
	# Check if this is a shared file, such as the options file
	if _shared:
		_path += "shared/"
	else:
		_path += "profiles/" + profile + "/"
	# Add the file extension
	_path += _filename + FILE_EXTENSION
	# Return the path
	return _path

#endregion

#region Saving & loading functions

func save(_filename: String, _shared: bool = false) -> void:
	# Check if the file is empty
	if not data.has(_filename):  
		BlankitRuntime.runtime_log("Skipping saving an empty file named \"" + _filename + FILE_EXTENSION + "\".")
		return
	# Set Blankit variables in the save file
	set_value(_filename, "blankit_game_index", game_index)
	set_value(_filename, "blankit_save_version", save_version)
	# Get the save path
	var _save_path = get_save_path(_filename, _shared)
	# Ensure the directory exists
	var _dir_path = _save_path.get_base_dir()
	var _dir = DirAccess.open(_dir_path)
	if not _dir:
		_dir = DirAccess.open("user://")  # Open root user directory
		_dir.make_dir_recursive(_dir_path)  # Now create directories properly
	var _file = FileAccess.open(_save_path, FileAccess.WRITE)
	if FileAccess.get_open_error() != OK:  # Check for errors after opening
		BlankitRuntime.runtime_log("Failed to open file \"" + _filename + "\" at \"" + _save_path + "\" for writing.", true)
		return
	_file.store_string(JSON.stringify(data[_filename], "\t"))
	_file.close()
	BlankitRuntime.runtime_log("Successfully saved \"" + _filename + "\" at \"" + _save_path + "\".")


func load(_filename:String, _shared: bool = false) -> void:
	# Get the save path
	var _save_path = get_save_path(_filename, _shared)
	# Check to see if the file exists
	if not FileAccess.file_exists(_save_path):
		BlankitRuntime.runtime_log("Was not able to find \"" + _filename + "\" at \"" + _save_path + "\".")
		return
	# Get the file
	var _file = FileAccess.open(_save_path, FileAccess.READ)
	if _file:
		# Get the content
		var _content = _file.get_as_text()
		_file.close()
		# Convert the JSON
		var _json = JSON.new()
		var _error = _json.parse(_content)
		if _error == OK: # Parsed successfully
			if _json.data.get("blankit_game_index", "blankit") != game_index or int(_json.data.get("save_file_version", 1)) < int(save_version):
				data[_filename] = {}
				BlankitRuntime.runtime_log("Wiping \"" + _filename + "\" at \"" + _save_path + "\" due to it not matching Blankit config settings.")
			else:
				data[_filename] = _json.data
				BlankitRuntime.runtime_log("Successfully loaded \"" + _filename + "\" at \"" + _save_path + "\".")
		else: # Failed to parse...
			BlankitRuntime.runtime_log("Failed to parse \"" + _filename + "\" at \"" + _save_path + "\".", true)

#endregion

#region Setting & getting value functions

func set_value(_filename:String, _key: String, _value):
	# Check to see if the file exists, if not, create it
	if not data.has(_filename):  
		data[_filename] = {}
	# Set the value
	data[_filename][_key] = _value

func get_value(_filename:String, _key: String, _default_value = null):
	# Check to see if the file exists, if not, return the default value
	if not data.has(_filename):
		return _default_value
	# Return the value of the key or the default value if it does not exist
	return data[_filename].get(_key, _default_value)

#endregion
