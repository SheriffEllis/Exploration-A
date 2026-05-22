class_name PlayerCharacter
extends CharacterBody3D

signal interaction_cursor_toggled(is_in_range: bool) ## signal to indicate that something can be interacted with in UI

# Movement constants
const JUMP_VELOCITY: float = 3.5
const BASE_MOVE_SPEED: float = 2.0
const MIDAIR_ADJUST_SPEED: float = 0.2
const FLOOR_FRICTION: float = 0.5
const AIR_FRICTION: float = 0.05

# Head constants
const MAX_LOOK_ANGLE: float = deg_to_rad(85.0)

@export_group("Interaction")
@export var grabber: Grabber
@export var interact_ray: RayCast3D
@export var prop_excluder: Area3D
@export var interact_orb: MeshInstance3D
@export var debug_orb: MeshInstance3D

@export_group("Head")
@export var yaw_pivot: Node3D
@export var pitch_pivot: Node3D
@export var camera: Camera3D

@export_group("Misc")
var flashlight_enabled := false
@export var flashlight: SpotLight3D
@export var flashlight_sfx: AudioStreamPlayer3D
@export var flashlight_flicker: AudioStreamPlayer3D
@export var coyote_timer: Timer
@export var footsteps: AudioStreamPlayer3D

@export_category("Crouching")
@export var normal_mesh: MeshInstance3D
@export var crouching_mesh: MeshInstance3D
@export var normal_collider: CollisionShape3D
@export var crouching_collider: CollisionShape3D

# Head variables
var mouse_sensitivity: float = 0.003
var twist_input: float = 0.0
var pitch_input: float = 0.0

# Movement variables
## flag for preventing player movement when controlling something else
var is_view_locked: float = false: set = set_view_locked
var is_movement_locked: float = false: set = set_movement_locked
var is_flying: float = false: set = set_is_flying
var move_speed: float = BASE_MOVE_SPEED
## memory bool for allowing coyote jump time
var can_jump: bool = true
var is_crouching: bool = false
## Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var tgt_velocity := Vector3.ZERO

# Interaction variables
var object: Node ## Last object interacted with
var interaction_cursor: bool = false ## memory bool to prevent signal spam to UI
var is_concentrating: bool = false ## is the player currently concentrating on an uncaptured touchscreen (holding down interact)

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Events.level_ready.connect(_on_level_ready)
	Events.flashlight_collected.connect(_on_flashlight_collected)

func _on_level_ready() -> void:
	interaction_cursor_toggled.connect(GameGlobals.GAME_UI._on_interaction_cursor_toggled)

func _on_flashlight_collected() -> void:
	flashlight_enabled = true

func _unhandled_input(event) -> void:
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED or event is not InputEventMouseMotion: return	
	# Don't move the view if rotating an object or view locked
	if not (grabber.is_rotating or is_view_locked):
		#var drag_factors := Vector2.ONE
		#if grabber.held_object is Draggable:
			## slow down camera movement when dragging by a factor or distance from dragged object
			#var factor := 1.0 - clampf((camera.global_position - grabber.held_object.global_position).length() * grabber.held_object.drag_resistance, 0.0, 1.0)
			#drag_factors.x = factor*0.15 if grabber.held_object.x_axis_lock else factor
			#drag_factors.y = factor*0.15 if grabber.held_object.y_axis_lock else factor
		twist_input = -event.relative.x * mouse_sensitivity #* drag_factors.x
		pitch_input = -event.relative.y * mouse_sensitivity #* drag_factors.y

func _input(event: InputEvent) -> void:
	# Toggle flashlight
	if event.is_action_pressed(&"flashlight") and flashlight_enabled and not flashlight_flicker.playing:
		flashlight.visible = not flashlight.visible
		flashlight_sfx.pitch_scale = 1.0 - float(not flashlight.visible)*0.1
		flashlight_sfx.play()
		if flashlight.visible:
			Events.flashlight_turned_on.emit()
		else:
			Events.flashlight_turned_off.emit()

func _physics_process(delta: float):
	# NOTE DEBUG: resets player position to origin
	if (position.y < -1000.0 and not is_flying) or Input.is_action_just_pressed(&"reset"):
		position = Vector3(0.0, 1.5, 1.0)

	# If controlling a console/seat/touchscreen, can't pause
	GameGlobals.GAME_UI.pause_menu.can_pause = not (is_movement_locked or is_view_locked)
	if not (is_movement_locked or is_concentrating):
		if is_flying:
			handle_flying()
		else:
			handle_coyote_timing(delta)
			handle_translation()
			handle_jump()
			#handle_crouch()
	if not is_view_locked:
		handle_camera_rotation()
		handle_interaction()

	# Apply translational forces to grabbed object and receive reaction forces
	# Don't apply forces if colliding with unliftable prop
	if grabber.held_object:
		velocity += grabber.drag(delta, global_position, prop_excluder.has_overlapping_bodies())
		grabber.handle_rotation(yaw_pivot.basis * pitch_pivot.basis)

	move_and_slide()
	
	footsteps.handle_footstep(self, delta)


func handle_coyote_timing(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta # Apply gravity.

		if can_jump and coyote_timer.is_stopped():
			coyote_timer.start()
	else:
		coyote_timer.stop()
		can_jump = true


func handle_translation() -> void:
	if Input.is_action_pressed(&"sprint"):
		move_speed = BASE_MOVE_SPEED * 2
	else:
		move_speed = BASE_MOVE_SPEED

	# Get the input direction and handle the movement/deceleration.
	var input_dir: Vector2 = Input.get_vector(&"move_left", &"move_right", &"move_forward", &"move_backward")
	var direction: Vector3 = (yaw_pivot.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction and can_jump:
		tgt_velocity.x = direction.x * move_speed
		tgt_velocity.z = direction.z * move_speed
	else:
		# arithmetic conditional, applies FLOOR_FRICTION if can jump (on floor) and AIR_FRICTION if not
		tgt_velocity *= 1.0 - (float(can_jump) * FLOOR_FRICTION) - (float(not can_jump) * AIR_FRICTION)
		tgt_velocity += direction * MIDAIR_ADJUST_SPEED
		tgt_velocity = tgt_velocity.limit_length(move_speed)

	velocity.x = tgt_velocity.x
	velocity.z = tgt_velocity.z


func handle_jump() -> void:
	if Input.is_action_pressed(&"jump") and can_jump:
		velocity.y = JUMP_VELOCITY
		can_jump = false


#func handle_crouch() -> void:
	#if Input.is_action_pressed(&"crouch"): # only trigger when crouch state changes
		#if not is_crouching:
			#is_crouching = true
			#crouch(is_crouching)
	#else:
		#if is_crouching:
			#is_crouching = false
			#crouch(is_crouching)


#func crouch(_is_crouching: bool) -> void:
	#normal_mesh.visible = not is_crouching
	#normal_collider.disabled = is_crouching
	#crouching_mesh.visible = is_crouching
	#crouching_collider.disabled = not is_crouching
#
	#if is_on_floor(): # account for crouch jumping and snap to floor when on floor
		#position.y += 1.0 - (2.0 * float(is_crouching))


func handle_flying() -> void:
	# Get the input direction and handle the movement/deceleration.
	var input_dir: Vector2 = Input.get_vector(&"move_left", &"move_right", &"move_forward", &"move_backward")
	var input_vert := int(Input.is_action_pressed(&"jump")) - int(Input.is_action_pressed(&"crouch"))
	var direction: Vector3 = (yaw_pivot.basis * pitch_pivot.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction.y += input_vert

	var fly_speed: float = move_speed + float(Input.is_action_pressed(&"sprint")) * 20.0
	tgt_velocity = direction * fly_speed

	velocity = tgt_velocity


func handle_camera_rotation() -> void:
	# Apply mouse view rotations
	yaw_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, -MAX_LOOK_ANGLE, MAX_LOOK_ANGLE)
	twist_input = 0.0
	pitch_input = 0.0


func handle_interaction() -> void:
	var object_in_range = interact_ray.get_object_in_range()
	if object_in_range and not grabber.held_object:
		if not interaction_cursor:
			interaction_cursor = true
			interaction_cursor_toggled.emit(interaction_cursor)

		#if object_in_range.get_parent() is TouchScreenUncaptured:
			#var new_touchscreen: TouchScreenUncaptured = object_in_range.get_parent()
			#if not touchscreen:
				#touchscreen = new_touchscreen
				##touchscreen._on_mouse_entered()
				#touchscreen.area_3d.emit_signal(&"mouse_entered")
			#elif touchscreen != new_touchscreen: # edge case of moving directly from screen to screen
				#touchscreen.area_3d.emit_signal(&"mouse_exited")
				#touchscreen = new_touchscreen
				#touchscreen.area_3d.emit_signal(&"mouse_entered")
			#touchscreen.project_mouse(interact_ray.get_collision_point())
			#is_concentrating = Input.is_action_pressed(&"interact") and touchscreen.is_concentration_required
			#touchscreen.is_concentrated_on = is_concentrating
		#else:
			#is_concentrating = false

		# Determine what object to pick up when interact key pressed
		if Input.is_action_just_pressed(&"interact"):
			#if object_in_range.get_parent() is TouchScreen:
				#object = object_in_range.get_parent()
			#else:
			object = object_in_range

			if object is Prop:
				var interact_pos = interact_ray.get_collision_point()
				# WARNING: Debug orb, remove in deployment
				debug_orb.global_position = interact_pos
				grabber.grab(object, interact_pos)
			#elif (object is Console) or (object is Seat) or (object is TouchScreenCaptured):
				#object.interact(self, not is_movement_locked)
			elif object is StaticInteractable:
				object.interact(self)
			#elif object is TouchScreenUncaptured:
				#touchscreen.project_mouse(interact_ray.get_collision_point(), true)
				#object = null
			else:
				push_warning("Wrong type of object grabbed")
	else:
		#if touchscreen:
			##touchscreen._on_mouse_exited()
			#touchscreen.area_3d.emit_signal(&"mouse_exited")
			#touchscreen = null
		if interaction_cursor and not grabber.held_object:
			# Update interaction_cursor to false when no longer holding object
			interaction_cursor = false
			interaction_cursor_toggled.emit(interaction_cursor)


# make sure the player doesn't drift when locked during movement
func set_movement_locked(new_value: bool) -> void:
	velocity = Vector3.ZERO
	is_movement_locked = new_value
	if is_movement_locked:
		interact_ray.set_interact_range(5.0) # extend reach when seated to reach buttons
	else:
		interact_ray.set_interact_range()


func set_view_locked(new_value: bool) -> void:
	GameGlobals.GAME_UI.crosshair.visible = not new_value
	is_view_locked = new_value


func set_is_flying(new_value: bool) -> void:
	if new_value:
		gravity = 0.0
		motion_mode = MOTION_MODE_FLOATING
	else:
		gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
		motion_mode = MOTION_MODE_GROUNDED

	is_flying = new_value


func _on_coyote_timer_timeout() -> void:
	can_jump = false
