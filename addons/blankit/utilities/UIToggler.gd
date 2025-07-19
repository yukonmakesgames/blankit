class_name UIToggler extends Object



const SAVED_MOUSE_FILTER_KEY := "__saved_mouse_filter"


static func enable(node : Node) -> void:
	node.propagate_call("set_disabled", [false])
	node.propagate_call("set_editable", [true])
	_restore_mouse_filter(node)


static func disable(node : Node) -> void:
	node.propagate_call("set_disabled", [true])
	node.propagate_call("set_editable", [false])
	_store_and_set_mouse_filter(node)


static func _store_and_set_mouse_filter(node : Node) -> void:
	if node is Control:
		var control := node as Control
		# Store current mouse filter if not already stored
		if not control.has_meta(SAVED_MOUSE_FILTER_KEY):
			control.set_meta(SAVED_MOUSE_FILTER_KEY, control.mouse_filter)
		# Disable mouse interaction
		control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	# Recurse for children
	for child in node.get_children():
		if child is Node:
			_store_and_set_mouse_filter(child)


static func _restore_mouse_filter(node : Node) -> void:
	if node is Control:
		var control := node as Control
		if control.has_meta(SAVED_MOUSE_FILTER_KEY):
			control.mouse_filter = control.get_meta(SAVED_MOUSE_FILTER_KEY)
			control.remove_meta(SAVED_MOUSE_FILTER_KEY)
	# Recurse for children
	for child in node.get_children():
		if child is Node:
			_restore_mouse_filter(child)
