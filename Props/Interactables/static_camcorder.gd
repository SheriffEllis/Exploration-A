extends MeshInstance3D

@export var tape_mesh : Node3D

func _ready() -> void:
	Events.interaction_prompted.connect($GlowHandler.start_glowing)

func _on_static_interactable_interacted(_player: CharacterBody3D) -> void:
	Events.camcorder_collected.emit()
	Events.hint_triggered.emit("[Press RMB to raise/lower camcorder]")
	Events.hint_triggered.emit("[Press LMB to capture an image]")
	visible = false
	tape_mesh.visible = false
	$StaticInteractable.toggle(false)
	$PickupAudio.play()
	$GlowHandler.stop_glowing()
