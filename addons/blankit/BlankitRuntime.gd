extends Node



#region Variables

const CONFIG_FILE = "res://configs/blankit.cfg"

var config = ConfigFile.new()

#endregion



#region Godot functions

func _ready() -> void:
	load_config()
	# Inform the user that Blankit has initialized
	print("Blankit (c) 2025-present Yukon Wainczak.")

#endregion

#region Logging functions

func runtime_log(_string:String, _error:bool = false):
	# Check to see if the user has logging enabled
	#if config.get_value("core", "enable_logging", true):
		# Print an error
		if _error:
			printerr("[Blankit Runtime] ERROR: " + _string)
		# Print a log
		else:
			print("[Blankit Runtime] " + _string)

#endregion

#region Config functions

func load_config():
	# Attempt to load the config
	var err = config.load(CONFIG_FILE)
	# If the config doesn't load, print an error
	if err != OK:
		runtime_log("No project config file found.", true)


func get_config_value(_system:String, _option:String, _default):
	return config.get_value(_system, _option, _default)

#endregion
