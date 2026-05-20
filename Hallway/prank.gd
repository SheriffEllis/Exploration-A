extends Area3D

@export var prison_location : Marker3D

func _on_body_entered(_body: Node3D) -> void:
	Events.flicker_triggered.emit()
	await wait_for_flicker()
	await wait_for_teleport()

func wait_for_flicker() -> void:
	if not GameGlobals.player.flashlight.visible:
		await Events.flashlight_turned_on
	Events.flicker_triggered.emit()
	return

func wait_for_teleport() -> void:
	await Events.flashlight_turned_off
	GameGlobals.player.global_position = prison_location.global_position
