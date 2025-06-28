extends BlktModuleScribe



func _get_file_path(_file : BlktSaving.File) -> String:
	# Set the base path
	var _path = "user://saves/"
	_path += Blankit.Saving.get_profile() + "/"
	# Add the file extension
	_path += _file.filename + file_extension
	# Return the path
	return _path


func _exists(_file: BlktSaving.File) -> bool:
	# Get the save path
	var _path = _get_file_path(_file)
	# Check to see if the file exists
	return FileAccess.file_exists(_path)

func _file_save(_file : BlktSaving.File) -> bool:
	# Get the save path
	var _path = _get_file_path(_file)
	# Ensure the directory exists
	var _dir_path = _path.get_base_dir()
	var _dir = DirAccess.open(_dir_path)
	if not _dir:
		_dir = DirAccess.open("user://")  # Open root user directory
		_dir.make_dir_recursive(_dir_path)  # Now create directories properly
	var _working = FileAccess.open(_path, FileAccess.WRITE)
	if FileAccess.get_open_error() != OK:  # Check for errors after opening
		Blankit.runtime_log("Failed to open file \"" + _file.filename + "\" at \"" + _path + "\" for writing.", true)
		return false
	_working.store_string(JSON.stringify(_file.data, "\t"))
	_working.close()
	Blankit.runtime_log("Successfully saved \"" + _file.filename + "\" at \"" + _path + "\".")
	return true


# To be overridden by user-made scribes
func _file_load(_file : BlktSaving.File) -> Dictionary:
	var _result = {}
	# Get the save path
	var _path = _get_file_path(_file)
	# Check to see if the file exists
	if not FileAccess.file_exists(_path):
		Blankit.runtime_log("Was not able to find \"" + _file.filename + "\" at \"" + _path + "\".")
		return _result
	# Get the file
	var _working = FileAccess.open(_path, FileAccess.READ)
	if _working:
		# Get the content
		var _content = _working.get_as_text()
		_working.close()
		# Convert the JSON
		var _json = JSON.new()
		var _error = _json.parse(_content)
		if _error == OK: # Parsed successfully
			if _json.data.get("blankit_index", "blkt") != Blankit.config.index or int(_json.data.get("save_file_version", 1)) < int(Blankit.config.save_file_version):
				Blankit.runtime_log("Wiping \"" + _file.filename + "\" at \"" + _path + "\" due to it not matching Blankit config settings.")
			else:
				_result = _json.data
				Blankit.runtime_log("Successfully loaded \"" + _file.filename + "\" at \"" + _path + "\".")
		else: # Failed to parse...
			Blankit.runtime_log("Failed to parse \"" + _file.filename + "\" at \"" + _path + "\".", true)
	return _result
