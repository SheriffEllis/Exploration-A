class_name Requisite extends Node3D

func _on_flicker_trigger_triggered() -> void:
	trigger()

func _on_body_entered(_body: Node3D) -> void:
	trigger()

func trigger() -> void:
	visible = true
