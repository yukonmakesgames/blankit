class_name SaveSlotButton extends Button



var slot : int = -1
var save : bool
var text_to_save : String


func setup(_slot : int, _save : bool, _text_to_save : String) -> void:
	slot = _slot
	save = _save
	text_to_save = _text_to_save
	
	var _slot_name = tr("BLANKIT_SAVING_SLOT") % slot
	var _slot_index = "slot" + str(slot)
	if slot == 0:
		_slot_name = tr("BLANKIT_SAVING_AUTOSAVE")
		_slot_index = "autosave"
	var _slot_text = Blankit.Saving.register_file.get_value(_slot_index + "_text", "blankit_unregistered")
	var _slot_datetime = Blankit.Saving.register_file.get_value(_slot_index + "_datetime", Time.get_datetime_string_from_system(false, true))
	
	text = _slot_name + ": "
	
	var _file = Blankit.Saving.File.new()
	_file.filename = Blankit.Saving.get_slot_filename(slot)
	
	if _file.exists():
		if _slot_text == "blankit_unregistered":
			text += tr("BLANKIT_SAVING_UNREGISTERED")
		else:
			text += _slot_datetime
			if _slot_text != "":
				text += " - " + _slot_text
	else:
		text += tr("BLANKIT_SAVING_EMPTY")


func on_pressed() -> void:
	if slot == -1:
		return
	if save:
		Blankit.Saving.save(slot, text_to_save)
	else:
		Blankit.Saving.load(slot)
