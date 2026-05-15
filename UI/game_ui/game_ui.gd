class_name GameUI
extends Node

const ACTION_PAUSE: StringName = &"ui_cancel"

@export var crosshair: Sprite2D
@export var fps_counter: Label
@export var pause_menu: PauseMenu

func _ready() -> void:
	pause_menu.paused.connect(Input.set_mouse_mode.bind(Input.MOUSE_MODE_VISIBLE), CONNECT_DEFERRED)
	pause_menu.resumed.connect(Input.set_mouse_mode.bind(Input.MOUSE_MODE_CAPTURED), CONNECT_DEFERRED)

func _process(_delta: float) -> void:
	if fps_counter.visible:
		fps_counter.text = str("FPS: ", Engine.get_frames_per_second())

func _on_interaction_cursor_toggled(highlighted: bool) -> void:
	crosshair.frame = int(highlighted)
