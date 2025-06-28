@icon("res://addons/blankit/icons/modals_blankit_icon.svg")
class_name BlktModals extends CanvasLayer



#region Variables

@onready var root: Control = $Root

var current_modal:Modal = null

#endregion



#region Godot functions

func _enter_tree() -> void:
	layer = Blankit.config.canvas_layer_layer + 0

func _ready() -> void:
	visible = false

#endregion

#region Modal functions

func spawn(_modal_scene:PackedScene, _stop_time:bool = true) -> Modal:
	# Check to see if there is a modal, if there is, stop
	if current_modal != null:
		return null
	# Enable modals
	visible = true
	# Spawn the modal
	var _spawned_modal:Control = _modal_scene.instantiate()
	root.add_child(_spawned_modal)
	current_modal = _spawned_modal as Modal
	if _stop_time:
		Blankit.TimeScale.add_object_stopping_time(current_modal)
	return current_modal


# Return if a modal is displaying
func is_displaying() -> bool:
	return visible


# Delete the current modal
func clear() -> void:
	if current_modal != null:
		Blankit.TimeScale.remove_object_stopping_time(current_modal)
		current_modal.set_process(false)
		current_modal.queue_free()
		current_modal = null
	visible = false

#endregion
