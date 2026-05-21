extends AudioStreamPlayer3D

@export var volume_curve : Curve
@onready var flashlight : SpotLight3D = get_parent()
var dark_period_passed := false

func _ready() -> void:
	Events.flicker_triggered.connect(start_flicker)
	set_process(false)

func start_flicker() -> void:
	flashlight.visible = true
	play()
	set_process(true)

func _process(_delta: float) -> void:
	if not playing:
		set_process(false)
		return
	var playback_percentage := get_playback_position()/stream.get_length()
	var amplitude := volume_curve.sample(playback_percentage)
	if playback_percentage > 0.5 and not dark_period_passed:
		flashlight.visible = false
		Events.flashlight_turned_off.emit()
		dark_period_passed = true
	if amplitude > 0.1 and dark_period_passed: # visibility is used for polling checks
		flashlight.visible = true
	flashlight.light_energy = amplitude
	volume_linear = amplitude

func _on_finished() -> void:
	Events.flashlight_turned_on.emit()
	dark_period_passed = false
	flashlight.light_energy = 1.0
	volume_db = 0
