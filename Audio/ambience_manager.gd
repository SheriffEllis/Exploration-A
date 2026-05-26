extends Node

@onready var sound_wind : AudioStreamPlayer = $Wind
@onready var environment : Environment = $WorldEnvironment.environment
var initial_background_energy : float

var footsteps_carpet : AudioStreamRandomizer = preload("uid://wmcs6hng7q6l")
var footsteps_wood : AudioStreamRandomizer = preload("uid://l3p3wfd4t13a")

func _ready() -> void:
	initial_background_energy = environment.background_energy_multiplier

func _on_area_3d_room_body_entered(_body: Node3D) -> void:
	sound_wind.stop()
	Events.floor_changed.emit(footsteps_carpet)
	Events.cam_cull_mask_changed.emit(5, true) # Outside visual layer
	Events.cam_cull_mask_changed.emit(3, false) # Hallway visual layer
	environment.background_energy_multiplier = initial_background_energy

func _on_area_3d_room_body_exited(_body: Node3D) -> void:
	sound_wind.play()
	Events.floor_changed.emit(footsteps_wood)
	Events.cam_cull_mask_changed.emit(5, false) # Outside visual layer
	Events.cam_cull_mask_changed.emit(3, true) # Hallway visual layer
	environment.background_energy_multiplier = 0
