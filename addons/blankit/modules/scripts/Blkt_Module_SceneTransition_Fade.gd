extends BlktModuleSceneTransition


@export_group("Tweening")
@export var anim_time : float = 0.2
@export var transition : Tween.TransitionType

@export_group("References")
@export var color_rect : ColorRect

var default_color : Color = Color.BLACK
var tween : Tween = null

#region Functions

func _cover() -> void:
	default_color = Color(color_rect.modulate, 1)
	color_rect.modulate = Color(default_color, 0)
	tween = create_tween()
	tween.tween_property(color_rect, "modulate", default_color, anim_time).set_trans(transition).set_ease(Tween.EASE_OUT)
	tween.tween_callback(covered)

func _reveal() -> void:
	tween = create_tween()
	tween.tween_property(color_rect, "modulate", Color(default_color, 0), anim_time).set_trans(transition).set_ease(Tween.EASE_IN)
	tween.tween_callback(revealed)

#endregion
