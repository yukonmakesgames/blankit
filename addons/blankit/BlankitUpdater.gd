@tool
extends EditorPlugin



#region Variables

const USER_CONFIG_PATH = "user://configs/blankit_updater.cfg"

var plugin = null
var dock = null
var user_config = ConfigFile.new()
var update_dialog = null
var force = false

#endregion



#region Config functions

func create_default_user_config():
	# Create the directory if it doesn't exist
	var _dir = DirAccess.open("user://configs")
	if not _dir:
		DirAccess.make_dir_recursive_absolute("user://configs")
	# Setup a default user config
	user_config.set_value("updater", "last_check", 0)
	user_config.set_value("updater", "skip_version", "-1")
	user_config.save(USER_CONFIG_PATH)

#endregion

#region Updating functions

func check_for_updates(_force=false):
	# Load config
	var err = user_config.load(USER_CONFIG_PATH)
	if err != OK:
		# Config doesn't exist, create default
		create_default_user_config()
	# Set force to what is passed along
	force = _force
	# Get plugin settings
	var check_enabled = dock.get_config_value("updating", "check_for_updates", true)
	if not check_enabled and not _force:
		return
	# Check if it's time to check based on frequency
	var last_check = user_config.get_value("updater", "last_check", 0)
	var current_time = Time.get_unix_time_from_system()
	var frequency = dock.get_config_value("updating", "update_check_frequency", 1)
	var check_interval = 0
	match frequency:
		0: # Every launch
			check_interval = 0
		1: # Daily
			check_interval = 86400 # 24 hours
		2: # Weekly
			check_interval = 604800 # 7 days
	# Actually compare the values
	if check_interval > 0 and current_time - last_check < check_interval and force == false:
		return
	# Update last check time
	user_config.set_value("updater", "last_check", current_time)
	user_config.save(USER_CONFIG_PATH)
	# Get repo from settings
	var repo = dock.get_config_value("updating", "github_repository", "yukonmakesgames/blankit")
	# Create HTTP request
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(on_request_completed)
	# GitHub API URL
	var url = "https://api.github.com/repos/" + repo + "/releases/latest"
	# Make request
	var headers = ["Accept: application/vnd.github.v3+json"]
	http_request.request(url, headers)


func on_request_completed(result, response_code, headers, body):
	# Catch a failure
	if result != HTTPRequest.RESULT_SUCCESS or response_code != 200:
		# Request failed
		plugin.editor_log("Update check failed. Error code: " + response_code)
		return
	# Parse JSON response
	var json = JSON.new()
	var error = json.parse(body.get_string_from_utf8())
	if error != OK:
		plugin.editor_log("Update check failed. Failed to parse response.")
		return
	var data = json.get_data()
	# Extract version from tag name (remove 'v' prefix if present)
	var latest_version = data["tag_name"]
	if latest_version.begins_with("v"):
		latest_version = latest_version.substr(1)
	# Skip check if user chose to skip this version
	var skip_version = user_config.get_value("updater", "skip_version", "")
	if latest_version == skip_version and force == false:
		return
	# Compare versions
	if is_version_newer(latest_version, plugin.get_plugin_version().replace("v", "")):
		show_update_dialog(latest_version, data["html_url"], data["body"])
	elif force:
		show_updated_dialog()

#endregion

#region Utility functions

func is_version_newer(_a, _b):
	# Split versions by dots (e.g., "1.2.3" -> ["1", "2", "3"])
	var _components_a = _a.split(".")
	var _components_b = _b.split(".")
	# Compare each component
	var max_length = max(_components_a.size(), _components_b.size())
	for i in range(max_length):
		var _current_a = 0
		var _current_b = 0
		if i < _components_a.size():
			_current_a = int(_components_a[i])
		if i < _components_b.size():
			_current_b = int(_components_b[i])
		if _current_a > _current_b:
			return true
		elif _current_a < _current_b:
			return false
	# If we get here, versions are identical
	return false

#endregion

#region Dialog functions

func show_updated_dialog():
	# Create the already updated dialog
	update_dialog = AcceptDialog.new()
	update_dialog.title = "Blankit " + plugin.get_plugin_version()
	update_dialog.dialog_text = "Blankit is up to date!"
	update_dialog.dialog_autowrap = true
	update_dialog.min_size = Vector2(512, 32)
	update_dialog.exclusive = false
	# Add to scene and show
	EditorInterface.get_base_control().add_child(update_dialog)
	update_dialog.popup_centered()


func show_update_dialog(_version, _url, _changelog):
	# Create dialog
	update_dialog = AcceptDialog.new()
	update_dialog.title = "Blankit " + plugin.get_plugin_version()
	update_dialog.dialog_text = "Blankit v" + _version + " is available!"
	update_dialog.dialog_hide_on_ok = false
	update_dialog.dialog_autowrap = true
	update_dialog.min_size = Vector2(512, 32)
	update_dialog.exclusive = false
	# Create the "View on GitHub" button
	var link_button = update_dialog.get_ok_button()
	link_button.text = "View on GitHub"
	link_button.pressed.connect(open_url.bind(_url))
	#Create the "Skip this version" button
	var skip_button = update_dialog.add_button("Skip this version", true, "skip_version")
	skip_button.pressed.connect(skip_version.bind(_version))
	# Create the "Don't ask again" button
	var dont_ask_button = update_dialog.add_button("Don't ask again", true, "dont_ask")
	dont_ask_button.pressed.connect(dont_ask_again)
	# Create the "Close" button
	var close_button = update_dialog.add_button("Close", true, "close")
	close_button.pressed.connect(close)
	# Add to scene and show
	EditorInterface.get_base_control().add_child(update_dialog)
	update_dialog.popup_centered()

#endregion

#region Button functions

func open_url(_url):
	OS.shell_open(_url)
	close()

func skip_version(_version):
	user_config.set_value("updater", "skip_version", _version)
	user_config.save(USER_CONFIG_PATH)
	close()

func dont_ask_again():
	plugin.set_config_value("updating", "check_for_updates", false)
	close()

func close():
	update_dialog.hide()
	update_dialog.queue_free()

#endregion
