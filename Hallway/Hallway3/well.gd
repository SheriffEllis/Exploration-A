extends Node

@export var well_floor : MeshInstance3D
@export var well_floor_water : MeshInstance3D
@export var well_floor_body : StaticBody3D

@export var stone_audio : AudioStreamPlayer3D
@export var water_audio : AudioStreamPlayer3D

func _on_sight_toggle_independent_3_toggled_door(is_on: bool) -> void:
	if(not is_on): return
	well_floor.visible = false
	well_floor_water.visible = false
	well_floor_body.collision_layer = 0
	
	stone_audio.play()
	water_audio.play()
	queue_free()
	
