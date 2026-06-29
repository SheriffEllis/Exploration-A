extends Panel

@export var volume_slider : Slider
@export var sensitivity_slider : Slider
@export var exposure_slider : Slider
@export var fov_slider : Slider
@export var GUI_scale_slider : Slider


func _on_update_pressed() -> void:
	#TODO reversal countdown for UI choices
	
	var window = get_window()
	window.content_scale_factor = GUI_scale_slider.value


func _on_sensitivity_slider_value_changed(value: float) -> void:
	const DEFAULT_SENSITIVITY = 0.003
	# value ranges from 1 to 100
	var new_sensitivity = DEFAULT_SENSITIVITY * value * 0.02
	GameGlobals.player.mouse_sensitivity = new_sensitivity


func _on_brightness_slider_value_changed(value: float) -> void:
	GameGlobals.ENVIRONMENT.environment.tonemap_exposure = value


#func _on_gui_scale_slider_value_changed(value: float) -> void:
	#ProjectSettings.set_setting("display/window/stretch/scale", value)
	#get_window().content_scale_factor = value
	


func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(0, value/50.0)


func _on_fov_slider_value_changed(value: float) -> void:
	GameGlobals.player.camera.default_fov = value
	GameGlobals.player.camera.fov = value


func _on_reset_pressed() -> void:
	volume_slider.value = 50
	volume_slider.value_changed.emit(volume_slider.value)
	
	sensitivity_slider.value = 50
	sensitivity_slider.value_changed.emit(sensitivity_slider.value)
	
	exposure_slider.value = 1.0
	exposure_slider.value_changed.emit(exposure_slider.value)
	
	fov_slider.value = 75
	fov_slider.value_changed.emit(fov_slider.value)
	
	GUI_scale_slider.value = 1.0
	_on_update_pressed()
