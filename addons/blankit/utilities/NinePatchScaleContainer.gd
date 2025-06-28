@tool
class_name NinePatchScaleContainer extends Container



@export var tile_scale: float = 1:
	set(value):
		tile_scale = value
		_resize_children()



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_resize_children()


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_RESIZED:
			_resize_children()


func _on_child_entered_tree(node: Node):
	_resize_child(node)


func _resize_child(node: Node):
	if "size" in node and "scale" in node:
		node.size = size if tile_scale == 0 else Vector2(size.x / tile_scale, size.y / tile_scale)
		node.scale = Vector2(1, 1) if tile_scale == 0 else Vector2(tile_scale, tile_scale)


func _resize_children():
	for node in get_children():
		_resize_child(node)
