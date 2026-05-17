extends Node3D

func _ready() -> void:
	GameGlobals.GAME_UI = $GameUI
	Events.level_ready.emit()
