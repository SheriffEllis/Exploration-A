extends Node

const HALLWAY_ENVIRONMENT : Environment = preload("uid://begdar7u38mqj")

var LEVEL: Level
var GAME_UI: GameUI
var ENVIRONMENT: WorldEnvironment
var player: PlayerCharacter

func change_environment(environment : Environment = HALLWAY_ENVIRONMENT) -> void:
	var previous_exposure := ENVIRONMENT.environment.tonemap_exposure
	environment.tonemap_exposure = previous_exposure
	ENVIRONMENT.environment = environment
