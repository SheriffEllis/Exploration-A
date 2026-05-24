class_name Door extends MeshInstance3D

@export_range(-180, 180, 0.001, "degrees") var open_angle = -100.0
@export var is_interactable := true :
	set(new_value):
		if door_interactable: # cannot use setter method before children have been initialiased
			door_interactable.set_collision_layer_value(2, new_value) # interaction layer (can player reticle detect)
		is_interactable = new_value

@export var is_locked := false
@export var key_id : int = 0

@onready var door_interactable : StaticInteractable = $Door/StaticInteractable
@onready var door_mesh : MeshInstance3D = $Door
@onready var sound_open : AudioStreamPlayer3D = $DoorOpenAudio
@onready var sound_close : AudioStreamPlayer3D = $DoorCloseAudio
@onready var sound_locked : AudioStreamPlayer3D = $DoorLockedAudio
var is_open := false
var tween : Tween

func _ready() -> void:
	is_interactable = is_interactable # cannot use setter method before children have been initialiased
	if is_locked:
		Events.key_collected.connect(_on_key_collected)

func _on_key_collected(collected_key_id: int) -> void:
	if key_id == collected_key_id: is_locked = false

func _on_static_interactable_interacted(_player: CharacterBody3D) -> void:
	if is_locked:
		sound_locked.play()
		return
	
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
	
	#door_interactable.set_collision_layer_value(3, not is_open) # walls layer (does player collide or not)

func toggle_door(is_on: bool) -> void:
	get_parent().visible = is_on
	is_interactable = is_on

func is_door_visible() -> bool:
	return visible and is_interactable
