class_name SeamlessTeleport extends Area3D

@export var constant_x := true ## True for constant X, False for constant Z
@export var other_teleporter : SeamlessTeleport
@export var adjustment := 0.0

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	var new_position = body.global_position
	if constant_x:
		new_position.z = other_teleporter.global_position.z + adjustment
	else:
		new_position.x = other_teleporter.global_position.x + adjustment
	body.global_position = new_position
