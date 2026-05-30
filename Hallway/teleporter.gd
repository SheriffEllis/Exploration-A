class_name Teleporter extends Area3D

@export var teleport_location : Marker3D
signal teleported


func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_trigger() -> void:
	_on_body_entered(null)

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
	GameGlobals.player.global_position = teleport_location.global_position
	#GameGlobals.player.yaw_pivot
	GameGlobals.player.global_basis = teleport_location.global_basis #.rotated(Vector3.UP,-90)
	teleported.emit()
