extends Label

func _ready() -> void:
	text = "v" + ProjectSettings.get_setting("application/config/version")
	if Blankit.is_mode_demo():
		text += " demo"
	if Blankit.is_mode_showcase():
		text += " showcase"
	if Blankit.is_debug():
		text += " debug"
