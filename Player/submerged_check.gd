extends Area3D

const UNDERWATER_ENVIRONMENT : Environment = preload("uid://c8w5ysd6hqk1m")
@onready var sound_underwater : AudioStreamPlayer = $UnderwaterAudio
@onready var sound_splash : AudioStreamPlayer3D = $SplashAudio

func _on_area_entered() -> void:
	GameGlobals.change_environment(UNDERWATER_ENVIRONMENT)
	sound_underwater.play()
	sound_splash.play()


func _on_area_exited() -> void:
	GameGlobals.change_environment()
	sound_underwater.stop()
