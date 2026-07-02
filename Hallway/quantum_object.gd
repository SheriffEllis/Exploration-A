class_name QuantumObject extends MeshInstance3D

var is_occupied := false ## Used to prevent disappearing when inside a quantum object

func toggle_door(is_on: bool) -> void:
	get_parent().visible = is_on
	#is_interactable = is_on

func is_door_visible() -> bool:
	#return visible and is_interactable
	return get_parent().visible

func _on_exclusion_area_body_entered(_body: Node3D) -> void:
	is_occupied = true

func _on_exclusion_area_body_exited(_body: Node3D) -> void:
	is_occupied = false
