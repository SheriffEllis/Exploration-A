extends Node3D

func _ready() -> void:
	GameGlobals.GAME_UI = $GameUI
	GameGlobals.player = $Player
	Events.level_ready.emit()
