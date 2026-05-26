extends Node3D

func _ready() -> void:
	GameGlobals.GAME_UI = $GameUI
	GameGlobals.player = $Player
	Events.level_ready.emit()
	
	Events.cam_cull_mask_changed.emit(5, false) # Outside visual layer
	Events.cam_cull_mask_changed.emit(3, true) # Hallway visual layer
	
	Events.flashlight_collected.emit()
	Events.camcorder_collected.emit()
