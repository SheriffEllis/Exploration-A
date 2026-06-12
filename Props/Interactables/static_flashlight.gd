extends MeshInstance3D

func _ready() -> void:
	Events.interaction_prompted.connect($GlowHandler.start_glowing)

func _on_static_interactable_interacted(_player: CharacterBody3D) -> void:
	Events.flashlight_collected.emit()
	Events.hint_triggered.emit("[Press F to toggle flashlight]")
	visible = false
	$StaticInteractable.toggle(false)
	$PickupAudio.play()
	$GlowHandler.stop_glowing()
