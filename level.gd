class_name Level extends Node3D

@export var skip_intro := false
@export var starting_location : Vector3
@export var starting_level : int

var interact_not_pressed := true
var last_safe_location := Vector3.ZERO

func _ready() -> void:
	GameGlobals.LEVEL = self
	GameGlobals.GAME_UI = $GameUI
	GameGlobals.player = $Player
	Events.level_ready.emit()
	if starting_location:
		# Tutorial 2: -27.0, 0, 50
		GameGlobals.player.global_position = starting_location
		last_safe_location = starting_location
		$AmbienceManager._on_area_3d_room_body_exited(null)
	#if starting_level:
	if skip_intro:
		Events.camcorder_collected.emit()
		Events.flashlight_collected.emit()
		GameGlobals.player.flashlight.visible = true
		Events.key_collected.emit(1)
		GameGlobals.GAME_UI.hint_label.text_queue = []
		GameGlobals.GAME_UI.dialogue_label.text_queue = []
		Events.hint_triggered.emit("[Intro Skipped]")
		return
	
	Events.hint_triggered.connect(_on_hint_triggered)
	
	await get_tree().create_timer(1).timeout
	Events.dialogue_triggered.emit("Dialogue test 1")
	Events.dialogue_triggered.emit("Dialogue test 2")
	
	await get_tree().create_timer(10).timeout
	if interact_not_pressed:
		Events.hint_triggered.emit("[Press E to Interact]")
	await Events.hint_queue_finished
	Events.hint_triggered.emit("[Press X to Squint]")
	


func _on_hint_triggered(_input_text: String) -> void:
	interact_not_pressed = false
	Events.hint_triggered.disconnect(_on_hint_triggered)
