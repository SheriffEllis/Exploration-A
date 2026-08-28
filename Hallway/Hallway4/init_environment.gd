extends Node

func _ready() -> void:
	GameGlobals.change_environment($WorldEnvironment.environment)
	$WorldEnvironment.queue_free()
	
	Events.floor_changed.emit(preload("uid://wmcs6hng7q6l"))
