extends Node

@export var well_floor : MeshInstance3D
@export var well_floor_water : MeshInstance3D
@export var well_floor_body : StaticBody3D

@export var stone_audio : AudioStreamPlayer3D
@export var water_audio : AudioStreamPlayer3D

var primed := false # prevent double triggering of signal

func _on_sight_toggle_independent_3_toggled_door(is_on: bool) -> void:
	if(primed or not is_on): return
	primed = true
	await Events.flashlight_turned_on # only trigger the well event once the player can see the pedestal
	well_floor.visible = false
	well_floor_water.visible = false
	well_floor_body.collision_layer = 0
	
	stone_audio.play()
	water_audio.play()
	queue_free()
	
