class_name TextTrigger extends Area3D

@export var dialogue_text_queue : Array[String]
@export var hint_text_queue : Array[String]
@export var oneshot := true


func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_triggered() -> void:
	_on_body_entered(null)

func _on_body_entered(_body: Node3D) -> void:
	for text in dialogue_text_queue:
		Events.dialogue_triggered.emit(text)
	for text in hint_text_queue:
		Events.hint_triggered.emit(text)
	if oneshot: queue_free()
