extends MeshInstance3D

@export var tape_mesh : Node3D

func _on_static_interactable_interacted(_player: CharacterBody3D) -> void:
	Events.camcorder_collected.emit()
	visible = false
	tape_mesh.visible = false
	$StaticInteractable.toggle(false)
	$PickupAudio.play()
