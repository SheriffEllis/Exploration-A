class_name WalkingZoneRadial extends WalkingZone

func get_up_direction() -> Vector3:
	var rel_pos := (global_position - GameGlobals.player.global_position) # get vector from player to center of radial zone
	rel_pos = rel_pos.rotated(Vector3.UP, -global_rotation.y) # align with global space
	rel_pos.x = 0.0 # remove Z coordinate (should only be radial along Z axis)
	rel_pos = rel_pos.rotated(Vector3.UP, global_rotation.y) # rotate back to local space
	return rel_pos.normalized()

func set_camera_basis(new_basis: Basis) -> void:
	GameGlobals.player.global_basis = new_basis
