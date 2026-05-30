class_name GameUI
extends Node

const ACTION_PAUSE: StringName = &"ui_cancel"

@export var crosshair: Sprite2D
@export var fps_counter: Label
@export var pause_menu: PauseMenu
@export var hint_label: HintLabel
@export var dialogue_label: DialogueLabel

func _ready() -> void:
	pause_menu.paused.connect(Input.set_mouse_mode.bind(Input.MOUSE_MODE_VISIBLE), CONNECT_DEFERRED)
	pause_menu.resumed.connect(Input.set_mouse_mode.bind(Input.MOUSE_MODE_CAPTURED), CONNECT_DEFERRED)
	Events.hint_queue_finished.connect(_on_hint_queue_finished)
	Events.dialogue_queue_finished.connect(_on_dialogue_queue_finished)

func _process(_delta: float) -> void:
	if fps_counter.visible:
		fps_counter.text = str("FPS: ", Engine.get_frames_per_second())

func _on_interaction_cursor_toggled(highlighted: bool) -> void:
	crosshair.frame = int(highlighted)

func _on_hint_queue_finished() -> void:
	if dialogue_label.text_queue.is_empty() and not dialogue_label.is_outputting:
		Events.all_text_queues_finished.emit()

func _on_dialogue_queue_finished() -> void:
	if hint_label.text_queue.is_empty() and not hint_label.is_outputting:
		Events.all_text_queues_finished.emit()
