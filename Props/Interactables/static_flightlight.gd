extends MeshInstance3D


func _on_static_interactable_interacted(_player: CharacterBody3D) -> void:
	Events.flashlight_collected.emit()
	visible = false
	$StaticInteractable.toggle(false)
	$PickupAudio.play()
