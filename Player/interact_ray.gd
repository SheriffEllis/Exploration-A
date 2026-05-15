extends RayCast3D

const DEFAULT_RANGE: float = 2.8

@export var interact_orb: MeshInstance3D

var interact_range: float = DEFAULT_RANGE: set = set_interact_range
var is_in_range: bool = false
var object: Object: get = get_object_in_range


func _ready() -> void:
	interact_range = DEFAULT_RANGE


func set_interact_range(new_value: float = DEFAULT_RANGE) -> void:
	interact_range = new_value
	target_position = Vector3(0.0, 0.0, -interact_range)
	interact_orb.position = target_position


func get_object_in_range() -> Object:
	var collider: Object = get_collider()

	if collider:
		if not collider.has_method(&"get_collision_layer_value"):
			is_in_range = false
			object = null
			return object
		# Don't interact through walls
		if not collider.get_collision_layer_value(2):
			is_in_range = false
		elif not is_in_range:
			is_in_range = true
	else:
		if is_in_range:
			is_in_range = false

	object = collider if is_in_range else null
	return object
