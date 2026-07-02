class_name SightToggle extends VisibleOnScreenNotifier3D

@export var hidden_doorframe : QuantumObject
@export var is_inverted := false
var is_on_camera := false

signal unobserved(who: SightToggle)
signal toggled_door(is_on: bool)

func _ready() -> void:
	#Events.flashlight_turned_off.connect(_on_flashlight_turned_off)
	Events.image_captured.connect(_on_image_captured)
	Events.image_deleted.connect(_on_image_deleted)
	if not screen_exited.is_connected(_on_screen_exited):
		screen_exited.connect(_on_screen_exited)
	
	set_layer_mask_value(1, false)
	set_layer_mask_value(6, true)

func is_observed() -> bool:
	return (is_on_screen() and GameGlobals.player.flashlight.visible) or is_on_camera or hidden_doorframe.is_occupied

## NOTE: if image capture method is ever changed to allow capture while an image 
## is already taken, is_observed() can no longer be used here
func _on_image_captured() -> void:
	if is_observed(): is_on_camera = true

func _on_image_deleted() -> void:
	is_on_camera = false

#func _on_flashlight_turned_off() -> void:
	#if is_on_screen() and not is_on_camera:
		#unobserved.emit(self)

func _on_screen_exited() -> void: #NOTE: occlusion culling is required to prevent seeing doors through walls
	if GameGlobals.player.flashlight.visible and not (is_on_camera or hidden_doorframe.is_occupied):
		unobserved.emit(self)


func toggle_door(visibility: bool, do_emit_signal := true) -> void:
	hidden_doorframe.toggle_door(visibility)
	if do_emit_signal: toggled_door.emit(visibility)

func is_door_visible() -> bool:
	return hidden_doorframe.is_door_visible()
