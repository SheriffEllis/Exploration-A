extends CSGBox3D

@export var inverted := false
@onready var doorframe : MeshInstance3D = $Doorframe

func _on_flicker_trigger_triggered() -> void:
	visible = not inverted
	doorframe.is_interactable = not inverted
