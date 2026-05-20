extends MeshInstance3D

@export var key_id : int = 0

func _on_static_interactable_interacted(_player: CharacterBody3D) -> void:
	Events.key_collected.emit(key_id)
	visible = false
	$StaticInteractable.toggle(false)
	$PickupAudio.play()
