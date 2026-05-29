class_name Door extends MeshInstance3D

@export_range(-180, 180, 0.001, "degrees") var open_angle = -100.0
@export var is_interactable := true :
	set(new_value):
		if door_interactable: # cannot use setter method before children have been initialiased
			door_interactable.set_collision_layer_value(2, new_value) # interaction layer (can player reticle detect)
			door_interactable.set_collision_layer_value(3, new_value) # walls layer (will player bump into)
		is_interactable = new_value

@export var is_locked := false
@export var key_id : int = 0

enum EyeType {
	NONE,
	NORMAL,
	INVERTED,
	RECESSIVE,
}
@export var eye_type := EyeType.NONE
#@export_enum("None", "Normal", "Inverted", "Recessive", "Travelling") var eye_type: int = 0
@onready var eye_decal : Decal = $Door/EyeDecal

enum EntangleType {
	NONE,
	TRAVELLING,
	TREE,
	SPIRAL,
	MINOTAUR,
	ARBITRARY_1,
	ARBITRARY_2,
	ARBITRARY_3,
	ONE_TO_ONE,
	ONE_TO_ONE_INV,
	ONE_TO_TWO,
	ONE_TO_ONE_AND_INV,
	ONE_TO_TWO_INV,
}
@export var entangle_type := EntangleType.NONE
#@export_enum("None", "1 to 1", "1 to 1 (inverted)", "1 to 2", "1 to 1 and 1 (inverted)", "1 to 2 (inverted)") var entanglement_type: int = 0
@onready var entangle_decal : Decal = $Door/EntangleDecal

@onready var door_interactable : StaticInteractable = $Door/StaticInteractable
@onready var door_mesh : MeshInstance3D = $Door
@onready var sound_open : AudioStreamPlayer3D = $DoorOpenAudio
@onready var sound_close : AudioStreamPlayer3D = $DoorCloseAudio
@onready var sound_locked : AudioStreamPlayer3D = $DoorLockedAudio
var is_open := false
var is_occupied := false ## Prevents walls reappearing while player is standing inside an open door
var tween : Tween

func _ready() -> void:
	is_interactable = is_interactable # cannot use setter method before children have been initialiased
	door_mesh.layers = layers
	eye_decal.layers = layers
	entangle_decal.layers = layers
	if is_locked:
		Events.key_collected.connect(_on_key_collected)
	match(eye_type):
		EyeType.NONE: eye_decal.visible = false # None
		EyeType.NORMAL: pass # texture is already set # Normal
		EyeType.INVERTED: eye_decal.texture_albedo = preload("uid://cnoxo75bl054v") # Inverted
		EyeType.RECESSIVE: eye_decal.texture_albedo = preload("uid://bia8jwn62bhx4") # Recessive
		_: push_error("Invalid Eye Type")
	match(entangle_type):
		EntangleType.NONE: entangle_decal.visible = false # None
		EntangleType.TRAVELLING: entangle_decal.texture_albedo = preload("uid://coqy63e7nt1f2") # travelling
		EntangleType.TREE: entangle_decal.texture_albedo = preload("uid://gkfibjsa4dys")
		EntangleType.SPIRAL: entangle_decal.texture_albedo = preload("uid://btqr18kwhmehl")
		EntangleType.MINOTAUR: entangle_decal.texture_albedo = preload("uid://dx5nxdnxsd3uk")
		EntangleType.ARBITRARY_1: entangle_decal.texture_albedo = preload("uid://ct0m0pamdu655")
		EntangleType.ARBITRARY_2: entangle_decal.texture_albedo = preload("uid://u65p3ksimody")
		EntangleType.ARBITRARY_3: entangle_decal.texture_albedo = preload("uid://bu11e5j8adu1f")
		EntangleType.ONE_TO_ONE: pass # texture is already set # 1 to 1
		EntangleType.ONE_TO_ONE_INV: entangle_decal.texture_albedo = preload("uid://ddmttfl3vxjmb") # 1 to 1 (inverted)
		EntangleType.ONE_TO_TWO: entangle_decal.texture_albedo = preload("uid://cjhmhpjh3oxud") # 1 to 2
		EntangleType.ONE_TO_ONE_AND_INV: entangle_decal.texture_albedo = preload("uid://csl1obkxgemp2") # 1 to 1 and 1 (inverted)
		EntangleType.ONE_TO_TWO_INV: entangle_decal.texture_albedo = preload("uid://bi5futkq33k16") # 1 to 2 (inverted)
		_: push_error("Invalid Entanglement Type")


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


func _on_exclusion_area_body_entered(_body: Node3D) -> void:
	is_occupied = true

func _on_exclusion_area_body_exited(_body: Node3D) -> void:
	is_occupied = false
