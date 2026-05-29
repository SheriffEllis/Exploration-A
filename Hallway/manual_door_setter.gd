extends Area3D


@export var sight_toggles : Array[SightToggle]
@export var states : Array[bool]


func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)


func _on_body_entered(_body: Node3D):
	if sight_toggles.size() != states.size():
		push_error("SightToggle array must be same size as States array")
		return
	
	for idx in range(sight_toggles.size()):
		if sight_toggles[idx].is_observed(): continue
		sight_toggles[idx].toggle_door(states[idx], false)
