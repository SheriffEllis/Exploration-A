## Forces collapse of doorway
extends Area3D

@export var sight_toggle : SightToggle

func _on_body_entered(_body: Node3D) -> void:
	if not sight_toggle.is_observed():
		sight_toggle.toggle_door(false)
