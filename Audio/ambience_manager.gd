extends Node

@onready var sound_wind : AudioStreamPlayer = $Wind

var footsteps_carpet : AudioStreamRandomizer = preload("uid://wmcs6hng7q6l")
var footsteps_wood : AudioStreamRandomizer = preload("uid://l3p3wfd4t13a")

func _on_area_3d_room_body_entered(_body: Node3D) -> void:
	sound_wind.stop()
	Events.floor_changed.emit(footsteps_carpet)

func _on_area_3d_room_body_exited(_body: Node3D) -> void:
	sound_wind.play()
	Events.floor_changed.emit(footsteps_wood)
