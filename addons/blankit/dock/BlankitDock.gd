@tool
extends Control
class_name BlankitDock



#region SYSTEMS

const SYSTEMS = [
	{
		"name": "Core",
		"icon": preload("res://addons/blankit/icons/node_blankit_icon.svg"),
		"options": [
			{
				"name": "Game index",
				"type": "string",
				"default": "blankit",
				"tooltip": "Set this to a simple index that represents your game. This is used across Blankit and should never be changed once set.
				Example: \"Turnip Boy Commits Tax Evasion\" could be simplified to \"tbcte\"."
			},
			{
				"name": "Enable logging",
				"type": "bool",
				"default": true,
				"tooltip": "Enable detailed logging for all Blankit systems."
			},
		]
	},
	{
		"name": "Saving",
		"icon": preload("res://addons/blankit/icons/save_blankit_icon.svg"),
		"options": [
			{
				"name": "Save file version",
				"type": "int",
				"default": 1,
				"min": 1,
				"max": 999,
				"step": 1,
				"tooltip": "Allows you to version your save files. Older versions will automatically be deleted. Increase this if you want to wipe saves."
			},
		]
	},
	{
		"name": "Updating",
		"icon": preload("res://addons/blankit/icons/update_blankit_icon.svg"),
		"options": [
			{
				"name": "Check for updates",
				"type": "bool",
				"default": true,
				"tooltip": "Check for Blankit updates on startup."
			},
			{
				"name": "Update check frequency",
				"type": "enum",
				"values": ["Every Launch", "Daily", "Weekly"],
				"default": 1,
				"tooltip": "How often to check for updates."
			},
			{
				"name": "GitHub repository",
				"type": "string",
				"default": "yukonmakesgames/blankit",
				"tooltip": "GitHub repository to check for updates."
			},
		]
	},
	{
		"name": "Fake",
		"icon": preload("res://addons/blankit/icons/node_blankit_icon.svg"),
		"options": [
			{
				"name": "Default Loading Screen",
				"type": "file",
				"default": "res://addons/blankit/scenes/default_loading.tscn",
				"filter": "*.tscn",
				"tooltip": "Default scene to use for loading screens"
			},
			{
				"name": "Minimum Loading Time",
				"type": "float",
				"default": 0.5,
				"min": 0.0,
				"max": 5.0,
				"step": 0.1,
				"tooltip": "Minimum time in seconds to show loading screen"
			}
		]
	},
]

#endregion

#region Variables

const CONFIG_FILE = "res://configs/blankit.cfg"

var plugin: EditorPlugin
var config = ConfigFile.new()
var dirty:bool = false
var current_system_index = 0
var update_checker = null

@onready var system_list = $Root/Sidebar/SystemList
@onready var options_container = $Root/OptionsScroll/OptionsContainer
@onready var save_button = $Root/Sidebar/SaveButton
@onready var default_button = $Root/Sidebar/DefaultButton
@onready var update_button = $Root/Sidebar/UpdateButton
@onready var version_label = $Root/Sidebar/VersionLabel

#endregion



#region Godot functions

func _process(_delta: float) -> void:
	# Display the save button with a (*) if there are unsaved changes
	if dirty:
		save_button.text = "Save (*)"
	else:
		save_button.text = "Save"

#endregion

#region Setup function

func setup(_plugin:EditorPlugin):
	# Set variables
	plugin = _plugin
	# Update the version number
	version_label.text = plugin.get_plugin_version()
	# Populate system list
	for _i in range(SYSTEMS.size()):
		var _system = SYSTEMS[_i]
		system_list.add_item(_system.name, _system.icon)
	# Load the config
	load_config()
	# Connect buttons
	save_button.pressed.connect(save_config)
	default_button.pressed.connect(on_default_pressed)
	system_list.item_selected.connect(on_system_selected)
	update_button.pressed.connect(on_update_check_pressed)
	# Load editor theme to load icons
	var editor_theme = EditorInterface.get_editor_theme()
	# Load icons for the buttons
	save_button.icon = editor_theme.get_icon("Save", "EditorIcons")
	default_button.icon = editor_theme.get_icon("Reload", "EditorIcons")
	update_button.icon = EditorInterface.get_editor_theme().get_icon("AssetLib", "EditorIcons")
	# Select first system by default
	if system_list.item_count > 0:
		system_list.select(0)
		on_system_selected(0)
	# Create and set up the update checker
	update_checker = preload("res://addons/blankit/BlankitUpdater.gd").new()
	update_checker.plugin = plugin
	update_checker.dock = self
	add_child(update_checker)
	# Check for updates
	update_checker.check_for_updates()

#endregion

#region Shutdown function

func shutdown() -> void:
	# Clean up update checker
	if update_checker:
		if update_checker.update_dialog != null:
			update_checker.update_dialog.hide()
			update_checker.update_dialog.free()
		update_checker.queue_free()
		update_checker = null

#endregion

#region Config functions

# Loads the config, or creates it if missing
func load_config():
	# Attempt to load the config
	var err = config.load(CONFIG_FILE)
	# If the config doesn't load, set the default and save it
	if err != OK:
		plugin.editor_log("No project config file found, creating new one...")
		set_default_config()
		save_config()

# Saves the config file
func save_config():
	# Create the config directory if it doesn't exist
	var _dir = DirAccess.open("res://configs")
	if not _dir:
		DirAccess.make_dir_recursive_absolute("res://configs")
	# Save the config and mark the file as not dirty
	config.save(CONFIG_FILE)
	plugin.editor_log("Project config saved.")
	dirty = false

# Allows you to alter config values and properly refresh the dock
func set_config_value(_system:String, _option:String, _value):
	config.set_value(_system, _option, _value)
	save_config()
	on_system_selected(current_system_index)

# Get a values stored in the config
func get_config_value(_system:String, _option:String, _default):
	return config.get_value(_system, _option, _default)

# Writes default settings if no config file exists
func set_default_config():
	config.clear()
	# Set default values from blankit_systems
	for _system in SYSTEMS:
		for _option in _system.options:
			config.set_value(_system.name.to_lower().replace(" ", "_"), _option.name.to_lower().replace(" ", "_"), _option.default)

#endregion

#region Menu functions

func on_system_selected(_index):
	# Set the value for the current system
	current_system_index = _index
	# Clear previous options
	for child in options_container.get_children():
		child.queue_free()
	# Get the current system
	var _system = SYSTEMS[_index]
	# Add header
	var _header = Label.new()
	_header.text = _system.name + " Options"
	_header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	options_container.add_child(_header)
	# Add separator
	var _separator = HSeparator.new()
	options_container.add_child(_separator)
	# Add options
	for _option in _system.options:
		# Create the Option HBox
		var _option_container = HBoxContainer.new()
		_option_container.add_theme_constant_override("separation", 10)
		# Make the option label
		var _label = Label.new()
		_label.text = _option.name
		_option_container.tooltip_text = _option.tooltip
		_label.custom_minimum_size.x = 256
		_option_container.add_child(_label)
		# Get the config indexes
		var _system_index = _system.name.to_lower().replace(" ", "_")
		var _option_index = _option.name.to_lower().replace(" ", "_")
		# Get the current value of the option
		var _current_value = config.get_value(_system_index, _option_index, _option.default)
		# Create the option's input
		var input = create_option_input(_system_index, _option, _current_value)
		input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		_option_container.add_child(input)
		# Finalize the creation of the option
		options_container.add_child(_option_container)


func create_option_input(_system_index, _option, _current_value):
	# Generate the option index
	var _option_index = _option.name.to_lower().replace(" ", "_")
	# Create a different input based on the option type
	match _option.type:
		"bool":
			var _checkbox = CheckBox.new()
			_checkbox.button_pressed = _current_value
			_checkbox.toggled.connect(on_value_changed.bind(_system_index, _option_index, _option.type))
			_checkbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			return _checkbox
		"int", "float":
			var _spin_box = SpinBox.new()
			_spin_box.min_value = _option.min
			_spin_box.max_value = _option.max
			_spin_box.step = _option.get("step", 1)
			_spin_box.value = _current_value
			_spin_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			if _option.type == "int":
				_spin_box.rounded = true
			_spin_box.value_changed.connect(on_value_changed.bind(_system_index, _option_index, _option.type))
			return _spin_box
		"string":
			var _line_edit = LineEdit.new()
			_line_edit.text = _current_value
			_line_edit.custom_minimum_size.x = 512
			_line_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			_line_edit.text_changed.connect(on_value_changed.bind(_system_index, _option_index, _option.type))
			return _line_edit
		"enum":
			var _option_button = OptionButton.new()
			for _i in range(_option.values.size()):
				_option_button.add_item(_option.values[_i], _i)
			_option_button.selected = _current_value
			_option_button.item_selected.connect(on_value_changed.bind(_system_index, _option_index, _option.type))
			_option_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			return _option_button
		"file":
			var _hbox = HBoxContainer.new()
			_hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			var _line_edit = LineEdit.new()
			_line_edit.text = _current_value
			_line_edit.custom_minimum_size.x = 512
			_line_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			_line_edit.text_changed.connect(on_value_changed.bind(_system_index, _option_index, _option.type))
			_hbox.add_child(_line_edit)
			var _button = Button.new()
			_button.text = "Browse"
			_button.pressed.connect(on_file_browse_pressed.bind(_line_edit, _option.get("filter", "*.*")))
			_hbox.add_child(_button)
			return _hbox
	# Default fallback
	var _label = Label.new()
	_label.text = "Unsupported option type: " + _option.type
	return _label


func on_value_changed(_value, _system_index, _option_index, _type):
	# Get the current value
	var _current_value = config.get_value(_system_index, _option_index, _value)
	# Set the current value if it's different and mark the config as dirty
	match _type:
		"bool":
			if bool(_current_value) != bool(_value):
				dirty = true
				config.set_value(_system_index, _option_index, bool(_value))
		"int":
			if int(_current_value) != int(_value):
				dirty = true
				config.set_value(_system_index, _option_index, int(_value))
		"float":
			if float(_current_value) != float(_value):
				dirty = true
				config.set_value(_system_index, _option_index, float(_value))
		"string", "file":
			if str(_current_value) != str(_value):
				dirty = true
				config.set_value(_system_index, _option_index, str(_value))
		"enum":
			if int(_current_value) != int(_value):
				dirty = true
				config.set_value(_system_index, _option_index, int(_value))


func on_file_browse_pressed(_line_edit, _filter):
	# Create a file dialog window
	var _file_dialog = FileDialog.new()
	_file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	_file_dialog.access = FileDialog.ACCESS_RESOURCES
	_file_dialog.filters = [_filter]
	# Spawn it and center it
	add_child(_file_dialog)
	_file_dialog.popup_centered_ratio(0.7)
	# Connect the file dialog to the line edit
	_file_dialog.file_selected.connect(func(path):
		_line_edit.text = path
		_line_edit.emit_signal("text_changed", path)
		_file_dialog.queue_free()
	)
	# Make the cancel button... cancel...
	_file_dialog.canceled.connect(func():
		_file_dialog.queue_free()
	)

#endregion

#region Button functions

func on_default_pressed():
	set_default_config()
	on_system_selected(0)


func on_update_check_pressed():
	update_checker.check_for_updates(true)  # Force check

#endregion
