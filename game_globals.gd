extends Node

const HALLWAY_ENVIRONMENT : Environment = preload("uid://begdar7u38mqj")

var LEVEL: Level
var GAME_UI: GameUI
var ENVIRONMENT: WorldEnvironment
var player: PlayerCharacter

var load_saved_game := false # request save file be loaded/ignored on scene initialisation

const LEVELS := {
	-1 : "uid://dnjtcvaxr54dt",
	1 : "uid://bnsblodj1ihor",
	2 : "uid://d0jdxlkx5i67m",
	3 : "uid://bku8imjjwm262",
	4 : "uid://dl8jmk517sqeb",
}

func change_environment(environment : Environment = HALLWAY_ENVIRONMENT) -> void:
	var previous_exposure := ENVIRONMENT.environment.tonemap_exposure
	environment.tonemap_exposure = previous_exposure
	ENVIRONMENT.environment = environment
