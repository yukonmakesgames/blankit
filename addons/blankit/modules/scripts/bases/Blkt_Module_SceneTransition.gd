class_name BlktModuleSceneTransition extends Node



#region Functions

# To be overridden by user-made scene transitions
func _cover() -> void:
	Blankit.runtime_log("Blankit Scene Transition Module Cover is not implemented!", true)
	covered()


func covered() -> void:
	pass


# To be overridden by user-made scene transitions
func _reveal() -> void:
	Blankit.runtime_log("Blankit Scene Transition Module Reveal is not implemented!", true)
	revealed()


func revealed() -> void:
	pass

#endregion
