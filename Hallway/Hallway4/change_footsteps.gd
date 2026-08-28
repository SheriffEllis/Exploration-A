extends Node

const HARD_FLOOR : AudioStreamRandomizer = preload("uid://l3p3wfd4t13a")
const SOFT_FLOOR : AudioStreamRandomizer = preload("uid://wmcs6hng7q6l")

func _on_wall_walking_zone_body_entered() -> void:
	Events.floor_changed.emit(HARD_FLOOR)

func _on_wall_walking_zone_body_exited() -> void:
	Events.floor_changed.emit(SOFT_FLOOR)
