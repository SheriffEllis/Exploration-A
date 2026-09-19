extends Node

func _ready() -> void:
	GameGlobals.change_environment($WorldEnvironment.environment)
	$WorldEnvironment.queue_free()
