extends MeshInstance3D

@export var true_light : OmniLight3D
@export var fake_light : SpotLight3D

func _ready() -> void:
	adjust_brightness()
	

func adjust_brightness() -> void:
	var light_energy : float = abs(randfn(1.0, 0.2))
	var adjustment_time := randf()/5.0
	var tween := create_tween()
	tween.tween_property(true_light,"light_energy", light_energy, adjustment_time)
	tween.tween_property(fake_light,"light_energy", light_energy, adjustment_time)
	await tween.finished
	adjust_brightness()
