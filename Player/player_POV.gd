class_name ShakingCamera
extends Camera3D

@onready var default_fov := fov # TODO read from player settings at startup

func _process(delta: float) -> void:
	handle_zoom(delta)

func handle_zoom(delta : float) -> void:
	#var control_seat_zoom_factor := 1.0 - (0.25 * (is_in_control_seat as int))
	var zoom_button_pressed_factor := 1.0 - (0.6 * (Input.is_action_pressed("zoom") as int))
	fov = lerpf(fov, default_fov * zoom_button_pressed_factor, delta * 10)
