class_name BlktModuleSceneTransition extends Node

signal is_covered
signal is_revealed

#region Functions

# To be overridden by user-made scene transitions
func _cover() -> void:
	Blankit.runtime_log("Blankit Scene Transition Module Cover is not implemented!", true)
	covered()


func covered() -> void:
	is_covered.emit()


# To be overridden by user-made scene transitions
func _reveal() -> void:
	Blankit.runtime_log("Blankit Scene Transition Module Reveal is not implemented!", true)
	revealed


func revealed() -> void:
	is_revealed.emit()

#endregion
