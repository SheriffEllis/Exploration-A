extends VisibleOnScreenNotifier3D

@export var prerequisite : Requisite
@export var entangled_door : SightToggleIndependent

var is_player_looking := false
var last_message_played := 0


func _ready() -> void:
	Events.image_captured.connect(_on_image_captured)


func _on_screen_entered() -> void:
	if not prerequisite.visible: return
	is_player_looking = true
	match(last_message_played):
		0:
			Events.dialogue_triggered.emit("Something should be here.")
			Events.flashlight_turned_off.connect(_on_flashlight_turned_off)
			last_message_played = 1
		1,2,3: pass
		4:
			Events.dialogue_triggered.emit("They seem to be linked.")
			queue_free()

func _on_screen_exited() -> void:
	is_player_looking = false


func _on_flashlight_turned_off() -> void:
	if prerequisite.visible and is_player_looking and last_message_played == 1:
		Events.dialogue_triggered.emit("It won't appear on its own.")
		last_message_played = 2


func _on_image_captured() -> void:
	if not prerequisite.visible: return
	if entangled_door.is_on_camera and entangled_door.is_door_visible():
		Events.hint_queue_cancelled.emit()
		Events.dialogue_queue_cancelled.emit()
		last_message_played = 4
