extends CSGBox3D

@export var sound_stone : AudioStreamPlayer3D
@export var new_safe_location : Marker3D

func _on_flicker_trigger_triggered() -> void:
	trigger()

func _on_body_entered(_body: Node3D) -> void:
	trigger()

func trigger() -> void:
	if visible: return
	if sound_stone:
		sound_stone.play()
	if new_safe_location:
		GameGlobals.LEVEL.last_safe_location = new_safe_location.global_position
	visible = true
	
