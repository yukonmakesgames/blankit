@icon("res://addons/blankit/icons/save_blankit_icon.svg")
class_name BlktSaving extends CanvasLayer



#region Signals

signal loaded
signal saved

#endregion

#region Variables

@export_category("Modules")
@export var default_scribe_module : PackedScene

@export_category("Packed Scenes")
@export var saving_modal : PackedScene

var scribe_module : BlktModuleScribe = null

var profile : String = ""
var loaded_slot : int = -1

var slot_file : File = File.new()
var register_file : File = File.new()
var options_file : File = File.new()
var achievements_file : File = File.new()

#endregion

#region File class

class File:
	var filename : String = ""
	var data : Dictionary = {}
	
	
	func get_file_path() -> String:
		return Blankit.Saving.scribe_module._get_file_path(self)
	
	
	func exists() -> bool:
		return Blankit.Saving.scribe_module._exists(self)
	
	
	func save() -> void:
		# Set Blankit variables in the save file
		set_value("blankit_index", Blankit.config.index)
		set_value("blankit_save_version", Blankit.config.save_file_version)
		# Save
		Blankit.Saving.scribe_module._file_save(self)
	
	
	func load() -> void:
		data = Blankit.Saving.scribe_module._file_load(self)
	
	
	func set_value(_key: String, _value) -> void:
		Blankit.Saving.get_profile()
		# Set the value
		data[_key] = _value
	
	
	func get_value(_key: String, _default = null):
		Blankit.Saving.get_profile()
		# Return the value of the key or the default value if it does not exist
		return data.get(_key, _default)

#endregion



#region Godot functions

func _enter_tree() -> void:
	layer = Blankit.config.canvas_layer_layer + 1
	var _scribe_module_to_spawn : PackedScene = default_scribe_module
	if Blankit.config.scribe_module_override != null:
		_scribe_module_to_spawn = Blankit.config.scribe_module_override
	scribe_module = _scribe_module_to_spawn.instantiate() as BlktModuleScribe
	add_child(scribe_module as Node)


func _ready() -> void:
	visible = false

#endregion

#region Profile functions

# Allows you to set what profile to save to
func set_profile(_value:String) -> void:
	if profile == "":
		profile = _value
		
		register_file.filename = "register"
		register_file.load()
		
		options_file.filename = "options"
		options_file.load()
		
		achievements_file.filename = "achievements"
		achievements_file.load()
	else:
		Blankit.runtime_log("Cannot set the profile multiple times!", true)


func get_profile() -> String:
	if profile == "":
		set_profile("default")
	return profile

#endregion

#region Utility functions

func get_slot_filename(_slot : int) -> String:
	var _result = "autosave"
	_slot = clampi(_slot, 0, Blankit.config.amount_of_slots)
	if _slot > 0:
		_result = "slot-" + str(_slot)
	return _result

#endregion

#region Saving & loading functions

func autosave(_text : String = "") -> void:
	save(0, _text)


func load(_slot : int) -> void:
	slot_file.filename = get_slot_filename(_slot)
	slot_file.load()
	loaded_slot = _slot
	loaded.emit()


func save(_slot : int = -1, _text : String = "") -> void:
	if _slot == -1:
		if loaded_slot == -1:
			return
		else:
			_slot == loaded_slot
	slot_file.filename = get_slot_filename(_slot)
	slot_file.save()
	loaded_slot = _slot
	var _slot_name = "slot" + str(_slot)
	if _slot == 0:
		_slot_name = "autosave"
	register_file.set_value(_slot_name + "_text", _text)
	register_file.set_value(_slot_name + "_datetime", Time.get_datetime_string_from_system(false, true))
	register_file.save()
	saved.emit()


func prompt_load() -> void:
	if not Blankit.Modals.is_displaying():
		var _modal = Blankit.Modals.spawn(saving_modal) as SavingModal
		_modal.setup(false, "")
	else:
		Blankit.runtime_log("Cannot spawn modal as one already exists!")


func prompt_save(_text : String) -> void:
	if not Blankit.Modals.is_displaying():
		var _modal = Blankit.Modals.spawn(saving_modal) as SavingModal
		_modal.setup(true, _text)
	else:
		Blankit.runtime_log("Cannot spawn modal as one already exists!")

#endregion

#region Setting & getting value functions

func set_value(_key: String, _value) -> void:
	slot_file.set_value(_key, _value)


func get_value(_key: String, _default = null):
	return slot_file.get_value(_key, _default)

#endregion
