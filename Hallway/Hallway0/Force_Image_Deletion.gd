extends Node

func trigger() -> void:
	Events.forced_image_deletion.emit()
