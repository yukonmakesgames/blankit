@icon("res://addons/blankit/icons/modals_blankit_icon.svg")
extends CanvasLayer



#region Variables

@onready var root: Control = $Root

var current_modal:BlankitModal = null

#endregion



#region Godot functions

func _ready() -> void:
	visible = false

#endregion

#region Modal functions

func spawn(_modal_scene:PackedScene) -> BlankitModal:
	# Check to see if there is a modal, if there is, stop
	if current_modal != null:
		return null
	# Enable modals
	visible = true
	# Spawn the modal
	var _spawned_modal:Control = _modal_scene.instantiate()
	get_tree().root.add_child(_spawned_modal)
	return _spawned_modal as BlankitModal


# Return if a modal is displaying
func is_displaying() -> bool:
	return visible


# Delete the current modal
func clear() -> void:
	if current_modal != null:
		current_modal.set_process(false)
		current_modal.queue_free()
		current_modal = null
		visible = false

#endregion
