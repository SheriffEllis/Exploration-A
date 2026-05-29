class_name SightToggleIndependent extends SightToggle
@export var prerequisite : Requisite
@export var entangled_toggles : Array[SightToggle]


@export_range(0.0, 1.0, 0.01) var appear_probability : float = 1.0
@export_range(0.0, 1.0, 0.01) var hide_probability := 1.0


func _ready() -> void:
	super()
	Events.flashlight_turned_off.connect(_on_flashlight_turned_off)
	for entangled_toggle : SightToggle in entangled_toggles:
		entangled_toggle.toggled_door.connect(_on_entangled_door_toggled)


func _on_entangled_door_toggled(is_on: bool) -> void:
	if not is_observed(): 
		if is_inverted: is_on = not is_on
		toggle_door(is_on, false) # don't emit signal to prevent infinite signal loop


func _on_flashlight_turned_off() -> void:
	if is_on_screen(): # don't cycle doors that aren't being observed: could cause doors the player isn't aware of to toggle
		collapse_state()

func _on_screen_exited() -> void: # NOTE: must use occlusion to acknowledge walls
	collapse_state()


func collapse_state() -> void:
	if is_observed(): return
	
	if prerequisite:
		if not prerequisite.visible: return
	
	for entagled_toggle : SightToggle in entangled_toggles:
		if entagled_toggle.is_observed():
			var is_on := entagled_toggle.is_door_visible()
			if is_inverted: is_on = not is_on
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
