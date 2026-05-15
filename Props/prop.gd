class_name Prop
extends RigidBody3D

## Can the player overcome the force of gravity when moving this object.
@export var is_liftable: bool = true

# Initial physics values to return to when not being grabbed
var GRAVITY_SCALE: float
var MASS: float
var INERTIA: Vector3


func _ready() -> void:
	set_collision_layer_value(2, true) # props should be interactibles by default
	set_collision_mask_value(3, true) # props should not fall through walls/floors by default
	
	# Turn on collisions with player if prop not liftable
	if not is_liftable:
		set_collision_layer_value(3, true) # unliftables collision layer
	
	GRAVITY_SCALE = gravity_scale
	MASS = mass
	INERTIA = inertia


func _physics_process(_delta: float) -> void:
	if global_position.y < -1000:
		linear_velocity = Vector3.ZERO
		position = Vector3(0.0, 5.0, 14.0) # Fall through the storage room ceiling


## Called when grabbed by player grabber
func grab() -> void:
	# Resume physics process if object physics locked
	freeze = false
	
	if is_liftable:
		# Remove gravity for liftable objects
		gravity_scale = 0.0
	
		# Normalise linear and rotational inertia to make movement consistent
		mass = 0.5
		inertia = Vector3(0.1,0.1,0.1)


## Called when let go by player grabber
func let_go() -> void:
	# Return to default values
	gravity_scale = GRAVITY_SCALE
	mass = MASS
	inertia = INERTIA
