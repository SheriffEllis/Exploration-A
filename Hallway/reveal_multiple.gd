extends Area3D

@export var to_hide : Array[Node3D]
@export var to_reveal : Array[Node3D]
@export var new_safe_location : Marker3D

func _on_body_entered() -> void:
	for node in to_hide:
		node.visible = false
	for node in to_reveal:
		node.visible = true
		if node is CollisionShape3D:
			node.disabled = false
	
	GameGlobals.LEVEL.last_safe_location = new_safe_location.global_position
	queue_free()
