extends Area3D

@export var hint_text : String
@export var oneshot := true

func _on_body_entered(_body: Node3D) -> void:
	Events.hint_triggered.emit(hint_text)
	if oneshot: queue_free()
