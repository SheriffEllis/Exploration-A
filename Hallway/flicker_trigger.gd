class_name FlickerTrigger extends Area3D

@export var required_sight : VisibleOnScreenNotifier3D ## What Notifier/SightToggle (if any) does the player need to be looking at to activate this flicker trigger.
@export var oneshot := true
var is_player_inside := false
signal triggered


func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)


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
	if required_sight:
		if not required_sight.is_on_screen():
			await required_sight.screen_entered
			if not is_player_inside: return
	Events.flicker_triggered.emit()


func wait_for_trigger() -> void:
	await Events.flashlight_turned_off
	triggered.emit()
