extends Node

@export var glow_material : Material = preload("uid://1oujwkm3smcs")
@export var mesh_instance : MeshInstance3D

func start_glowing() -> void:
	mesh_instance.material_overlay = glow_material

func stop_glowing() -> void:
	mesh_instance.material_overlay = null
