extends VisibleOnScreenNotifier3D

@export var prerequisite : Requisite
@export var entangled_door : SightToggleIndependent

var is_player_looking := false
var first_message_played := false


func _ready() -> void:
	Events.image_captured.connect(_on_image_captured)


func _on_screen_entered() -> void:
	is_player_looking = true
	if prerequisite.visible and not first_message_played:
		Events.dialogue_triggered.emit("Something should be here.")
		first_message_played = true
		Events.flashlight_turned_off.connect(_on_flashlight_turned_off)

func _on_screen_exited() -> void:
	is_player_looking = false


func _on_flashlight_turned_off() -> void:
	if prerequisite.visible and is_player_looking and first_message_played:
		Events.dialogue_triggered.emit("It won't appear on its own.")
		queue_free()

func _on_image_captured() -> void:
	if entangled_door.is_on_camera and entangled_door.is_door_visible():
		Events.hint_queue_cancelled.emit()
		Events.dialogue_queue_cancelled.emit()
		queue_free()
