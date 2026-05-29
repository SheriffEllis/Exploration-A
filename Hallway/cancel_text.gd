extends Area3D

@export var cancel_hints := true
@export var cancel_dialogue := true
@export var oneshot := true

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)


func _on_body_entered(_body: Node3D) -> void:
	if cancel_hints: Events.hint_queue_cancelled.emit()
	if cancel_dialogue: Events.dialogue_queue_cancelled.emit()
	if oneshot: queue_free()
