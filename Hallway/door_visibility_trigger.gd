extends VisibleOnScreenNotifier3D
@export var prerequisite : Node3D

@export var hidden_doorframe : Door

func _ready() -> void:
	Events.flashlight_turned_off.connect(_on_flashlight_turned_off)
	
func _on_flashlight_turned_off() -> void:
	reveal_door()

func _on_screen_exited() -> void:
	reveal_door()

func reveal_door() -> void:
	if prerequisite.visible:
		hidden_doorframe.toggle_door(true)
		queue_free()
