extends Area3D

@export var hidden_doorway : Node3D
@export var hidden_doorframe : Node3D

func _on_body_entered(_body: Node3D) -> void:
	await wait_for_flicker()
	await wait_for_unhide()
	queue_free()

func wait_for_flicker() -> void:
	if not GameGlobals.player.flashlight.visible:
		await Events.flashlight_turned_on
	Events.flicker_triggered.emit()
	return

func wait_for_unhide() -> void:
	await Events.flashlight_turned_off
	hidden_doorway.visible = true
	hidden_doorframe.is_interactable = true
