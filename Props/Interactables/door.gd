extends StaticInteractable

var is_open := false
var tween : Tween
@onready var door_mesh : MeshInstance3D = get_parent()
@onready var sound_open : AudioStreamPlayer3D = $DoorOpenAudio
@onready var sound_close : AudioStreamPlayer3D = $DoorCloseAudio
@onready var open_angle : float = $"../..".open_angle

func interact(_player: CharacterBody3D):
	if tween: tween.pause()
	tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	if is_open:
		tween.tween_property(door_mesh,"rotation_degrees", Vector3(0,0,0), 1.6)
		sound_open.stop()
		sound_close.play()
	else:
		tween.tween_property(door_mesh,"rotation_degrees", Vector3(0,-open_angle,0), 3.22)
		sound_close.stop()
		sound_open.play()
	is_open = not is_open
	
	set_collision_layer_value(3, not is_open) # walls layer
