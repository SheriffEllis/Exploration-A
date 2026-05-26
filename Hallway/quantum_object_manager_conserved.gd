class_name QuantumObjectManagerConserved extends QuantumObjectManager

@export var conserved_quantity := 1 ## Amount of objects to maintain between collapses

func collapse_states(_new_state: bool) -> void:
	if conserved_quantity >= entangled_toggles.size(): 
		push_error("Conserved quantity cannot equal or exceed the number of SightToggles")
		return
	
	entangled_toggles.shuffle()
	var quantity_countdown := conserved_quantity
	for entangled_toggle : SightToggle in entangled_toggles:
		if entangled_toggle.is_observed(): continue
		
		entangled_toggle.toggle_door(quantity_countdown > 0)
		quantity_countdown -= 1
