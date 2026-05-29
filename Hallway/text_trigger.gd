class_name TextTrigger extends Area3D

@export var text_queue : Array[String]
@export var is_hint := true ## True for hint text, False for dialogue text
@export var oneshot := true


func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)


func _on_body_entered(_body: Node3D) -> void:
	for text in text_queue:
		if is_hint:
			Events.hint_triggered.emit(text)
		else:
			Events.dialogue_triggered.emit(text)
	if oneshot: queue_free()
