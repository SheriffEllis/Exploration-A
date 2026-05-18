extends Node

func _input(event: InputEvent) -> void:
	if event.is_action("free_mouse"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
