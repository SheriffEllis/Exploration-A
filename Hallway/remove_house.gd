extends Node


func _on_enable_tutorial_1_body_entered(_body: Node3D) -> void:
	GameGlobals.LEVEL.remove_house()
