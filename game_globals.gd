extends Node

var GAME_UI: GameUI

var player: PlayerCharacter: set = set_player
signal player_changed(new_player: PlayerCharacter)


func set_player(new_player: PlayerCharacter) -> void:
	player = new_player
	player_changed.emit(new_player)
