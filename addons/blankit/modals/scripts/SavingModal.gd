class_name SavingModal extends Modal

@export_group("Packed Scenes")
@export var save_slot_button : PackedScene

@export_group("References")
@export var header_label : Label
@export var save_list : VBoxContainer

func setup(_save : bool, _text_to_save : String) -> void:
	if _save:
		Blankit.Saving.saved.connect(_close)
		header_label.text = tr("BLANKIT_SAVING_SAVE")
	else:
		Blankit.Saving.loaded.connect(_close)
		header_label.text = tr("BLANKIT_SAVING_LOAD")
	for _i in Blankit.config.amount_of_slots:
		var _new_button : SaveSlotButton = save_slot_button.instantiate()
		_new_button.setup(_i, _save, _text_to_save)
		save_list.add_child(_new_button)
