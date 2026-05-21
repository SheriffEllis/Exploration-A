extends VisibleOnScreenNotifier3D
@export var prerequisite : Node3D

@export var hidden_doorway : CSGBox3D
@export var hidden_doorframe : MeshInstance3D

func _ready() -> void:
	Events.flashlight_turned_off.connect(_on_flashlight_turned_off)
	
func _on_flashlight_turned_off() -> void:
	reveal_door()

func _on_screen_exited() -> void:
	reveal_door()

func reveal_door() -> void:
	if prerequisite.visible:
		hidden_doorway.visible = true
		hidden_doorframe.is_interactable = true
		queue_free()
