extends Panel

@export var volume_slider : Slider
var default_volume : float
@export var sensitivity_slider : Slider
var default_sensitivity : float
@export var exposure_slider : Slider
var default_exposure : float
@export var fov_slider : Slider
var default_fov : float
@export var GUI_scale_slider : Slider
var default_GUI_scale : float

func _ready() -> void:
	Events.level_ready.connect(_on_level_ready)


func _on_level_ready() -> void:
	default_volume = volume_slider.value
	default_sensitivity = sensitivity_slider.value
	default_exposure = exposure_slider.value
	default_fov = fov_slider.value
	default_GUI_scale = GUI_scale_slider.value
	
	var settings := ConfigFile.new()
	var err := settings.load("user://settings.cfg")
	if err != OK:
		return
	
	volume_slider.value = settings.get_value("Audio", "master_volume")
	volume_slider.value_changed.emit(volume_slider.value)
	sensitivity_slider.value = settings.get_value("Controls", "mouse_sensitivity")
	sensitivity_slider.value_changed.emit(sensitivity_slider.value)
	exposure_slider.value = settings.get_value("View", "exposure")
	exposure_slider.value_changed.emit(exposure_slider.value)
	fov_slider.value = settings.get_value("View", "field_of_view")
	fov_slider.value_changed.emit(fov_slider.value)
	GUI_scale_slider.value = settings.get_value("GUI", "gui_scale")
	get_window().content_scale_factor = GUI_scale_slider.value


func _on_save_pressed() -> void:
	var settings := ConfigFile.new()
	
	settings.set_value("Audio", "master_volume", volume_slider.value)
	settings.set_value("Controls", "mouse_sensitivity", sensitivity_slider.value)
	settings.set_value("View", "exposure", exposure_slider.value)
	settings.set_value("View", "field_of_view", fov_slider.value)
	settings.set_value("GUI", "gui_scale", GUI_scale_slider.value)
	
	settings.save("user://settings.cfg")


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


func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(0, value/50.0)


func _on_fov_slider_value_changed(value: float) -> void:
	GameGlobals.player.camera.default_fov = value
	GameGlobals.player.camera.fov = value


func _on_reset_pressed() -> void:
	volume_slider.value = default_volume
	volume_slider.value_changed.emit(volume_slider.value)
	sensitivity_slider.value = default_sensitivity
	sensitivity_slider.value_changed.emit(sensitivity_slider.value)
	exposure_slider.value = default_exposure
	exposure_slider.value_changed.emit(exposure_slider.value)
	fov_slider.value = default_fov
	fov_slider.value_changed.emit(fov_slider.value)
	GUI_scale_slider.value = default_GUI_scale
	get_window().content_scale_factor = GUI_scale_slider.value
