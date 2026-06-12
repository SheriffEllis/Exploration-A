extends Area3D


func _on_body_entered(_body: Node3D) -> void:
	GameGlobals.LEVEL.remove_house()
	queue_free()
