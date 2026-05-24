extends CSGBox3D

@export var inverted := false
@onready var doorframe : Door = $Doorframe

func _on_flicker_trigger_triggered() -> void:
	doorframe.toggle_door(not inverted)
