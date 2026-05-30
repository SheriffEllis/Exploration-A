class_name Level extends Node3D

@export var skip_intro := false
@export var starting_location : Vector3
@export var starting_level : int

var interact_pressed := false
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
	
	Events.camcorder_collected.connect(_on_interact_pressed)
	Events.flashlight_collected.connect(_on_interact_pressed)
	
	# TODO: title screen
	# TODO: intro argument cutscene
	
	await get_tree().create_timer(2).timeout
	Events.dialogue_triggered.emit("Call me impetuous or just curious,")
	Events.dialogue_triggered.emit("But a little look around isn't going to hurt.")

	await Events.all_text_queues_finished
	Events.hint_triggered.emit("[Press X to Squint]")
	await get_tree().create_timer(10).timeout
	if not interact_pressed:
		Events.dialogue_triggered.emit("I should gather my equipment from the table first.")
		Events.hint_triggered.emit("[Press E to Interact]")


func _on_interact_pressed() -> void:
	interact_pressed = true
