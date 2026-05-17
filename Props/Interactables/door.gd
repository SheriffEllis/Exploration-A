extends StaticInteractable

var is_open := false
@onready var door_mesh : MeshInstance3D = get_parent()

func interact(_player: CharacterBody3D):
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	if is_open:
		tween.tween_property(door_mesh,"rotation_degrees", Vector3(0,0,0), 0.5)
	else:
		tween.tween_property(door_mesh,"rotation_degrees", Vector3(0,-130,0), 0.5)
	is_open = not is_open
	
	set_collision_layer_value(3, not is_open) # walls layer
