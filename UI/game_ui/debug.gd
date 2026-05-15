extends Node

@export var game_ui : GameUI

func _ready() -> void:
	LimboConsole.register_command(fps, "fps", "toggle visibility of fps counter")

func fps():
	game_ui.fps_counter.visible = !game_ui.fps_counter.visible
	LimboConsole.info("Fps counter visibility set to " + str(game_ui.fps_counter.visible))
