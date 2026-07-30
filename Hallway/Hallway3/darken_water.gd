extends Area3D

var tween : Tween

func _on_body_entered() -> void:
	tween = create_tween().set_parallel()
	tween.tween_property(GameGlobals.player.flashlight, "light_energy", 0, 7)
	tween.tween_property(GameGlobals.ENVIRONMENT.environment, "fog_density", 1, 7)
	tween.tween_property(GameGlobals.ENVIRONMENT.environment, "fog_light_color", Color(), 7)
