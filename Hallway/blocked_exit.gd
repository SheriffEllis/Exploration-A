extends CSGBox3D

@onready var sound_stone : AudioStreamPlayer3D = $StoneAudio

func _on_flicker_trigger_triggered() -> void:
	if not visible:
		sound_stone.play()
	visible = true
