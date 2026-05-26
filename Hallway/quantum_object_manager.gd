class_name QuantumObjectManager extends Node

@export var prerequisite : Node3D
@export var entangled_toggles : Array[SightToggle]
@export var requires_consensus := true ## Do all toggles in the collection need to be unobserved for any to toggle?

func _ready() -> void:
	Events.flashlight_turned_off.connect(_on_flashlight_turned_off)
	for entangled_toggle : SightToggle in entangled_toggles:
		entangled_toggle.unobserved.connect(_on_toggle_unobserved)

func _on_flashlight_turned_off() -> void: # WARNING extremely unperformant, consider alternatives if ever using a large number of these
	# Check at least one of the objects is in view
	var who : SightToggle
	for entangled_toggle : SightToggle in entangled_toggles:
		if entangled_toggle.is_on_screen() and not entangled_toggle.is_on_camera:
			who = entangled_toggle
			break
	if not who: return
	_on_toggle_unobserved(who)

func _on_toggle_unobserved(who: SightToggle) -> void:
	if prerequisite:
		if not prerequisite.visible: return
	
	var new_state := not who.is_door_visible()
	if who.is_inverted: new_state = not new_state
	
	if requires_consensus:
		for entangled_toggle : SightToggle in entangled_toggles:
			if entangled_toggle.is_observed(): return
	
	collapse_states(new_state)


func collapse_states(new_state: bool) -> void:
	for entangled_toggle : SightToggle in entangled_toggles:
		if entangled_toggle.is_observed(): continue
		
		var this_new_state := new_state
		if entangled_toggle.is_inverted: this_new_state = not this_new_state
		#var xor := (new_state and not entangled_toggle.is_inverted) or (not new_state and entangled_toggle.is_inverted)
		entangled_toggle.toggle_door(this_new_state)
