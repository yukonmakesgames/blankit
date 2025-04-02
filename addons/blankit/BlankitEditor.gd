@tool
extends EditorPlugin
class_name BlankitEditor



#region AUTOLOADS

const AUTOLOADS: Dictionary = {
	"BlankitRuntime":			"res://addons/blankit/BlankitRuntime.gd",
	
	"BlankitModals":			"res://addons/blankit/systems/modals/BlankitModals.tscn",
	"BlankitSaving":			"res://addons/blankit/systems/saving/BlankitSaving.gd",
	"BlankitTime":				"res://addons/blankit/systems/time/BlankitTime.gd",
}

#endregion

#region Variables

var dock = null
var shortcut

#endregion



#region Godot functions

func _enter_tree():
	# Add the autoloads
	for autoload in AUTOLOADS:
		add_autoload_singleton(autoload, AUTOLOADS[autoload])
	# Create and add the dock
	dock = preload("res://addons/blankit/dock/BlankitDock.tscn").instantiate()
	add_control_to_dock(DOCK_SLOT_RIGHT_UR, dock)
	dock.setup(self)
	# Inform the user that Blankit has initialized
	print("Blankit " + self.get_plugin_version() + " (c) 2025-present Yukon Wainczak.")


func _exit_tree():
	# Remove autoloads
	for autoload in AUTOLOADS:
		remove_autoload_singleton(autoload)
	# Remove the dock
	dock.shutdown()
	remove_control_from_docks(dock)
	dock.queue_free()
	# Inform the user that Blankit has successfully unloaded
	editor_log("Successfully unloaded.")

#endregion

#region Logging functions

func editor_log(_string:String, _error:bool = false):
	# Check to see if the user has logging enabled
	if dock.get_config_value("core", "enable_logging", true):
		# Print an error
		if _error:
			printerr("[Blankit Editor] ERROR: " + _string)
		# Print a log
		else:
			print("[Blankit Editor] " + _string)

#endregion
