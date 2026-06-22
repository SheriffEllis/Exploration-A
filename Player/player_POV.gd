class_name ShakingCamera
extends Camera3D

@onready var default_fov := fov # TODO read from player settings at startup

func _ready() -> void:
	Events.cam_cull_mask_changed.connect(_on_cam_cull_mask_changed)

func _on_cam_cull_mask_changed(layer_num: int, new_value: bool) -> void:
	set_cull_mask_value(layer_num, new_value)

func _process(delta: float) -> void:
	handle_zoom(delta)

func handle_zoom(delta : float) -> void:
	#var control_seat_zoom_factor := 1.0 - (0.25 * (is_in_control_seat as int))
	var zoom_button_pressed_factor := 1.0 - (0.8 * (Input.is_action_pressed("zoom") as int))
	fov = lerpf(fov, default_fov * zoom_button_pressed_factor, delta * 10)
