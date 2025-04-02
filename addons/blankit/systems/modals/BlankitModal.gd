@icon("res://addons/blankit/icons/modal_blankit_icon.svg")
extends Control
class_name BlankitModal



#region Overridable functions

# To be overridden by user-made modals
func _close():
	push_warning("_close() not implemented in " + str(get_class()))
	closed()  # Default behavior in case it isn't overridden

#endregion

#region Blankit Modals connection functions

func closed() -> void:
	BlankitModals.clear()

#endregion
