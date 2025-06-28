@icon("res://addons/blankit/icons/modal_blankit_icon.svg")
class_name Modal extends Control



#region Overridable functions

# To be overridden by user-made modals
func _close():
	closed()  # Default behavior in case it isn't overridden

#endregion

#region Blankit Modals connection functions

func closed() -> void:
	Blankit.Modals.clear()

#endregion
