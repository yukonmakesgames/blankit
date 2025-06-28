class_name BlktModuleScribe extends Node



#region Variables

@export var file_extension = ".json"

#endregion



#region Functions

# To be overridden by user-made scribes
func _get_file_path(_file : BlktSaving.File) -> String:
	Blankit.runtime_log("Blankit Scribe Module Get Path is not implemented!", true)
	return ""


func _exists(_file: BlktSaving.File) -> bool:
	Blankit.runtime_log("Blankit Scribe Module Exists is not implemented!", true)
	return false


# To be overridden by user-made scribes
func _file_save(_file : BlktSaving.File) -> bool:
	Blankit.runtime_log("Blankit Scribe Module File Save is not implemented!", true)
	return false


# To be overridden by user-made scribes
func _file_load(_file : BlktSaving.File) -> Dictionary:
	Blankit.runtime_log("Blankit Scribe Module File Load is not implemented!", true)
	return {}

#endregion
