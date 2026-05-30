extends MeshInstance3D

@export var cam: Camera3D
@export var screen: MeshInstance3D
@export var viewport: SubViewport

@export var cam_up : Marker3D
@export var cam_down : Marker3D

@export var texture_rect_pause_play : TextureRect 
@export var sound_pause : AudioStreamPlayer3D
@export var sound_play : AudioStreamPlayer3D
var pause_texture := preload("uid://drqhmsg2svrmo")
var play_texture := preload("uid://oy6jvw6xba2p")
var is_up := true

func _ready() -> void:
	screen.get_active_material(1).emission_texture = viewport.get_texture()
	Events.camcorder_collected.connect(_on_camcorder_collected)
	Events.cam_cull_mask_changed.connect(_on_cull_mask_changed)

func _on_camcorder_collected() -> void:
	visible = true
	await get_tree().create_timer(1.5).timeout
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", cam_down.position, 1.0)
	is_up = false

func _on_cull_mask_changed(layer_num: int, new_value: bool) -> void:
	cam.set_cull_mask_value(layer_num, new_value)
	
func _input(event: InputEvent) -> void:
	if not visible: return
	if event.is_action_pressed("hide_camera"):
		var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
		var new_pos := cam_down.position if is_up else cam_up.position
		tween.tween_property(self, "position", new_pos, 1.0)
		is_up = not is_up
	if event.is_action_pressed("capture_image"):
		if viewport.render_target_update_mode == SubViewport.UPDATE_WHEN_VISIBLE:
			viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
			sound_pause.play()
			texture_rect_pause_play.texture = pause_texture
			Events.image_captured.emit()
		else:
			viewport.render_target_update_mode = SubViewport.UPDATE_WHEN_VISIBLE
			sound_play.play()
			texture_rect_pause_play.texture = play_texture
			Events.image_deleted.emit()
