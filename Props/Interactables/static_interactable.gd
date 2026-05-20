class_name StaticInteractable extends AnimatableBody3D

signal interacted(player: CharacterBody3D)

func interact(player: CharacterBody3D) -> void:
	interacted.emit(player)

func toggle(is_on: bool) -> void:
	set_collision_layer_value(2, is_on) # Interaction collision layer
