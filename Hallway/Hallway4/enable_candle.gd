extends Node

var candle = preload("uid://cp06nqc5sus67").instantiate()

func _ready() -> void:
	Events.flashlight_disabled.emit()
	Events.camcorder_disabled.emit()
	var location : Marker3D = GameGlobals.player.get_node("YawPivot/PitchPivot/CandleLocation")
	location.add_child(candle)

func _exit_tree() -> void:
	candle.queue_free()
	Events.flashlight_collected.emit()
	Events.camcorder_collected.emit()
