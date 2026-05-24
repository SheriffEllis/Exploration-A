class_name SightToggle extends VisibleOnScreenNotifier3D
@export var prerequisite : Node3D
@export var entangled_toggles : Array[SightToggle]
@export var inverted_entanglement := false

@export var hidden_doorframe : Door

@export_range(0.0, 1.0, 0.01) var appear_probability : float = 1.0
@export_range(0.0, 1.0, 0.01) var hide_probability := 1.0

signal toggled_door(is_on: bool)
var is_on_camera := false


func _ready() -> void:
	Events.flashlight_turned_off.connect(_on_flashlight_turned_off)
	Events.image_captured.connect(_on_image_captured)
	Events.image_deleted.connect(_on_image_deleted)
	for entangled_toggle : SightToggle in entangled_toggles:
		entangled_toggle.toggled_door.connect(_on_entangled_door_toggled)


func is_observed() -> bool:
	return is_on_screen() and GameGlobals.player.flashlight.visible or is_on_camera

## NOTE: if image capture method is ever changed to allow capture while an image 
## is already taken, is_observed() can no longer be used here
func _on_image_captured() -> void:
	if is_observed(): is_on_camera = true

func _on_image_deleted() -> void:
	is_on_camera = false

func _on_entangled_door_toggled(is_on: bool) -> void:
	if not is_observed(): 
		if inverted_entanglement: is_on = not is_on
		toggle_door(is_on, false) # don't emit signal to prevent infinite signal loop

func _on_flashlight_turned_off() -> void:
	if is_on_screen(): # don't cycle doors that aren't being observed: could cause doors the player isn't aware of to toggle
		collapse_state()

func _on_screen_exited() -> void: #FIXME OnScreenNotifier doesn't acknowledge walls
	collapse_state()


func collapse_state() -> void:
	if is_observed(): return
	
	if prerequisite:
		if not prerequisite.visible: return
	
	for entagled_toggle : SightToggle in entangled_toggles:
		if entagled_toggle.is_observed():
			var is_on := entagled_toggle.is_door_visible()
			if inverted_entanglement: is_on = not is_on
			toggle_door(is_on)
			return
	
	if not is_door_visible():
		if is_zero_approx(appear_probability): return
		if randf() <= appear_probability:
			toggle_door(true)
	else:
		if is_zero_approx(hide_probability): return
		if randf() <= hide_probability:
			toggle_door(false)

func toggle_door(visibility: bool, do_emit_signal := true) -> void:
	hidden_doorframe.toggle_door(visibility)
	if do_emit_signal: toggled_door.emit(visibility)

func is_door_visible() -> bool:
	return hidden_doorframe.is_door_visible()
