class_name BlankitConfig extends Resource


enum Mode { 
	## The game should act as a finalized, released project.
	RELEASE,
	## The game should act as a demo that is uploaded to a storefront.
	DEMO,
	## The game should act as a showcase demo to be used at conventions or demo events.
	SHOWCASE
	}

@export_group("Project")
## Set this to a simple index that represents your game. This is used across Blankit and should never be changed once set. Example: "Turnip Boy Commits Tax Evasion" could be simplified to "tbcte".
@export var index : String = "blkt"
## The mode the game is in. This will be carried into any builds.
@export var mode : Mode = Mode.RELEASE
## What layer should Blankit draw it's canvases? This should be above all your game canvases. Blankit will reserve 8 (eight) layers above this for it's tools.
@export_range(-128, 120, 1) var canvas_layer_layer : int = 64

@export_group("Saving")
## Allows you to inject custom saving logic into Blankit Saving. Use this if you need to save files as anything but unencrypted JSON files.
@export var scribe_module_override : PackedScene
## Allows you to version your save files. Older versions will automatically be deleted. Increase this if you want to wipe saves.
@export_range(1, 999, 1) var save_file_version : int = 1
## Set the amount of save slots you want the player to have. Setting this value to zero will force saving in only the autosave slot.
@export_range(0, 8, 1) var amount_of_slots : int = 8
