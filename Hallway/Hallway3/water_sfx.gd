extends Area3D

var footsteps_wood : AudioStreamRandomizer = preload("uid://l3p3wfd4t13a")
var footsteps_water : AudioStreamRandomizer = preload("uid://b1yrtkggj41d1")

func _on_body_entered() -> void:
	Events.floor_changed.emit(footsteps_water)


func _on_body_exited() -> void:
	Events.floor_changed.emit(footsteps_wood)
