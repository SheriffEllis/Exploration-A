## Gradually shift the flashlight colour to the desired value (usually to desaturate it)
extends Area3D

@export var desired_color : Color
@export var transition_time := 1.0

func trigger() -> void:
	var tween := create_tween()
	tween.tween_property(GameGlobals.player.flashlight, "light_color", desired_color, transition_time)
