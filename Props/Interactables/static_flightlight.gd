extends MeshInstance3D


func _on_static_interactable_interacted(_player: CharacterBody3D) -> void:
	Events.flashlight_collected.emit()
	Events.hint_triggered.emit("[Press F to toggle flashlight]")
	visible = false
	$StaticInteractable.toggle(false)
	$PickupAudio.play()
