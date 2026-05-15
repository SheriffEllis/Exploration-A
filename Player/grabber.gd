class_name Grabber extends Node3D

@export_category("Grabber")
@export_group("Strengths")
@export var THROW_STRENGTH := 10.0
@export_subgroup("PID values")
@export var TRANSLATION_P := 10000.0
@export var TRANSLATION_D := 800.0
@export var ROTATION_P := 6000.0
@export var ROTATION_D := 200.0
@export_subgroup("Prop Pull")
@export var MIN_PULL_DISTANCE := 1.5
@export var PULL_MULTIPLIER := 80.0

@export_group("Scrolling")
@export var MAX_LENGTH := 3.0
@export var MIN_LENGTH := 1.2
@export var SCROLL_SENSITIVITY := 0.2
# Default starting grabber distance
var current_length = 2.0 : set = set_current_length

# Currently held object
var held_object : Prop

## Is currently held object being rotated, prevents rotation of player view
var is_rotating := false
var rot_x := 0.0
var rot_y := 0.0
var mouse_sensitivity := 0.003
var rot_limit := 1.0

var target_rotation_relative := Basis()
var target_rotation_global := Basis()

var grabbing_position_relative := Vector3.ZERO

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


# Called when the node enters the scene tree for the first time.
func _ready():
	position.z = -current_length
	set_physics_process(false)


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			current_length += SCROLL_SENSITIVITY
			current_length = clamp(current_length, MIN_LENGTH, MAX_LENGTH)
			#position.z = -current_length
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			current_length -= SCROLL_SENSITIVITY
			current_length = clamp(current_length, MIN_LENGTH, MAX_LENGTH)
			#position.z = -current_length
	
	if event is InputEventMouseMotion and is_rotating:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			rot_y = clamp(event.relative.x * mouse_sensitivity, -rot_limit, rot_limit)
			rot_x = clamp(event.relative.y * mouse_sensitivity, -rot_limit, rot_limit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):		
	# Throw object when throw key (combination) pressed
	if Input.is_action_just_pressed(&"throw"):
		throw()
		return
	
	# Drop object when interact key pressed again or object deleted
	if Input.is_action_just_pressed(&"interact") or not held_object:
		let_go()
		return
	
	is_rotating = Input.is_action_pressed(&"rotate")
	
	# Torque-based method
	var torque_vec = held_object.basis.x.cross(target_rotation_global.x) # torque along x axis
	torque_vec += held_object.basis.y.cross(target_rotation_global.y) # torque along y axis
	# Apply PD Controller
	var applied_torque = (torque_vec * ROTATION_P) - (held_object.get_angular_velocity() * ROTATION_D)
	held_object.apply_torque(applied_torque * delta)


func grab(object : Prop, grabbing_position_global : Vector3):
	held_object = object
	held_object.grab() # run specific prop's logic for being grabbed
	
	# Sets initial rotation to current rotation of picked up object
	target_rotation_relative = global_basis.inverse() * held_object.global_basis
	if not held_object.is_liftable:
		# Relative position to apply forces to
		grabbing_position_relative = grabbing_position_global - held_object.global_position
	
	# Resume grabber physics process
	set_physics_process(true)


func let_go():
	# Let go and remove reference to held object
	if held_object: held_object.let_go()
	held_object = null
	
	# Don't process grabber physics if no object is being held
	set_physics_process(false)
	is_rotating = false


func throw():
	held_object.apply_central_impulse(-THROW_STRENGTH * global_basis.z)
	let_go()


## Apply a force to the object in the direction of the grabber
## unliftable objects return a force to apply back to the player
func drag(delta, player_position, is_colliding) -> Vector3:	
	var reaction_force_vector := Vector3.ZERO
	var force_vector := Vector3.ZERO
	var applied_force := Vector3.ZERO
	
	# Edge case of object being removed while being held
	if not held_object:
		let_go()
		return reaction_force_vector
	
	if held_object.is_liftable:
		force_vector = global_position - held_object.global_position
		# Apply PD controller
		applied_force = (force_vector * TRANSLATION_P) - (held_object.get_linear_velocity() * TRANSLATION_D)
		held_object.apply_central_force(applied_force * delta)
	else:
		if is_colliding:
			# Do nothing if the currently held object is unliftable and being collided with
			return reaction_force_vector
		
		# force upon non-liftables applied relative to player instead of grabber
		force_vector = player_position - (held_object.global_position + grabbing_position_relative)
		var force_len = force_vector.length()
		
		# Player gets pulled by non-liftable objects
		if force_len > MIN_PULL_DISTANCE:
			force_vector = force_vector.normalized() * (force_len - MIN_PULL_DISTANCE) # start from min pull distance
			reaction_force_vector = - force_vector
			reaction_force_vector.y = 0 # remove vertical component to prevent levitation
			# proportional to the square of distance
			reaction_force_vector = reaction_force_vector * reaction_force_vector.length() * PULL_MULTIPLIER * delta
		else:
			force_vector = Vector3.ZERO
		
		# Prevent overcoming the force of gravity by clamping the vertical force
		var force_limit = gravity * held_object.mass * 0.5
		applied_force = (force_vector * TRANSLATION_P) - (held_object.get_linear_velocity() * TRANSLATION_D)
		applied_force.y = clamp(applied_force.y, -force_limit, force_limit)
		
		held_object.apply_force(applied_force * delta, grabbing_position_relative)
		
	return reaction_force_vector


## Called by player when already grabbed object. Applies mouse movement to rotate object
func handle_rotation(combined_pivot_basis : Basis):
	target_rotation_global = combined_pivot_basis * target_rotation_relative
	if is_rotating:
		target_rotation_relative = target_rotation_relative.rotated(Vector3.RIGHT, rot_x)
		target_rotation_relative = target_rotation_relative.rotated(Vector3.UP, rot_y)
		target_rotation_relative = target_rotation_relative.orthonormalized()
	rot_x = 0.0
	rot_y = 0.0


func set_current_length(new_value) -> void:
	position.z = -new_value
	current_length = new_value
