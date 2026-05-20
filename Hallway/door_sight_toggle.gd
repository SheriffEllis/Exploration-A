extends VisibleOnScreenNotifier3D
@export var prerequisite : Node3D

@export var hidden_doorway : CSGBox3D
@export var hidden_doorframe : MeshInstance3D

@export_range(0.0, 1.0, 0.01) var appear_probability : float = 1.0
@export_range(0.0, 1.0, 0.01) var hide_probability := 1.0

func _ready() -> void:
	Events.flashlight_turned_off.connect(_on_flashlight_turned_off)
	
func _on_flashlight_turned_off() -> void:
	toggle_door()

func _on_screen_exited() -> void:
	toggle_door()

func toggle_door() -> void:
	if prerequisite:
		if not prerequisite.visible: return
	if not hidden_doorway.visible:
		if is_zero_approx(appear_probability): return
		if randf() <= appear_probability:
			hidden_doorway.visible = true
			hidden_doorframe.is_interactable = true
	else:
		if is_zero_approx(hide_probability): return
		if randf() <= hide_probability:
			hidden_doorway.visible = false
			hidden_doorframe.is_interactable = false
