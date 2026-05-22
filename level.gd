extends Node3D

var tutorial_required := true

func _ready() -> void:
	GameGlobals.GAME_UI = $GameUI
	GameGlobals.player = $Player
	Events.level_ready.emit()
	Events.hint_triggered.connect(_on_hint_triggered)
	
	await get_tree().create_timer(10).timeout
	if tutorial_required:
		Events.hint_triggered.emit("[Press E to Interact]")
	Events.hint_triggered.emit("[Press X to Squint]")

func _on_hint_triggered(_input_text: String) -> void:
	tutorial_required = false
	Events.hint_triggered.disconnect(_on_hint_triggered)
