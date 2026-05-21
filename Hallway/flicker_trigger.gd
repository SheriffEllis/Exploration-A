class_name FlickerTrigger extends Area3D

@export var oneshot := true
var is_player_inside := false
signal triggered

func _on_body_entered(_body: Node3D) -> void:
	is_player_inside = true
	await wait_for_flicker()
	if not is_player_inside: return
	await wait_for_trigger()
	if oneshot: queue_free()

func _on_body_exited(_body: Node3D) -> void:
	is_player_inside = false

func wait_for_flicker() -> void:
	if not GameGlobals.player.flashlight.visible:
		await Events.flashlight_turned_on
		if not is_player_inside: return
	Events.flicker_triggered.emit()

func wait_for_trigger() -> void:
	await Events.flashlight_turned_off
	triggered.emit()
