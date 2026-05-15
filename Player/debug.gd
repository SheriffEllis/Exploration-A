extends Node

@export var player: CharacterBody3D
@export var grabber: Grabber
@export var collider: CollisionShape3D

@export var camera: Camera3D
const ENV_FULLBRIGHT : Environment = preload("uid://cwkr1pv4s7bc0")

@export var screen_ui: Node

func _ready() -> void:
	LimboConsole.register_command(teleport_player, "teleport player", "teleports player to specified local/global coordinates")
	LimboConsole.register_command(spawn_prop, "spawn prop", "spawns the specified prop in front of the player.")
	LimboConsole.register_command(see, "see", "toggle layer of cull mask for player camera")
	LimboConsole.register_command(fullbright, "fullbright", "toggle player view to have universal background lighting")
	LimboConsole.register_command(mouse_capture_toggle, "mousemode", "toggle mouse mode between captured and uncaptured without pausing")
	LimboConsole.register_command(fly, "fly", "toggle player flight")
	LimboConsole.register_command(noclip, "noclip", "toggle player collisions")
	LimboConsole.register_command(view_distance, "viewdistance", "set distance of camera far plane")
	LimboConsole.register_command(god_mode, "godmode", "toggle fly, noclip, fullbright, see, and view_distance all at once")

func teleport_player(coordinates: Vector3, world_space: bool = false):
	if world_space:
		player.global_position = coordinates
		LimboConsole.info("Moved player to " + str(coordinates) + " in GLOBAL coordinates")
	else:
		player.position = coordinates
		LimboConsole.info("Moved player to " + str(coordinates) + " in LOCAL coordinates")

func spawn_prop(item_id: String):
	var item: Item = ItemRegistry.instantiate_item(item_id)

	if not is_instance_valid(item):
		LimboConsole.info("Error: That item does not exist")
		return

	var prop: Prop = item.summon()

	if not is_instance_valid(prop):
		LimboConsole.info("Error: That item has no corresponding prop")
		return

	player.get_parent().add_child(prop) # add as child of interior, not player
	prop.global_position = grabber.global_position
	LimboConsole.info("Summoned " + item_id + " at " + str(prop.global_position) + " in GLOBAL coordinates")


func see(cull_layer: int):
	if cull_layer < 1 or cull_layer > 20:
		LimboConsole.info("Invalid cull layer, must be from 1 to 20")
		return
	var new_value : bool = !camera.get_cull_mask_value(cull_layer)
	camera.set_cull_mask_value(cull_layer, new_value)
	LimboConsole.info("Set layer " + str(cull_layer) + " to " + str(new_value))

func fullbright():
	if camera.environment: camera.environment = null
	else: camera.environment = ENV_FULLBRIGHT

func mouse_capture_toggle():
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		GameGlobals.GAME_UI.pause_menu.pause_override = true
		LimboConsole.info("Mouse uncaptured")
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		GameGlobals.GAME_UI.pause_menu.pause_override = false
		LimboConsole.info("Mouse captured")

func fly():
	player.is_flying = !player.is_flying
	LimboConsole.info("Fly mode set to " + str(player.is_flying))

func noclip():
	collider.disabled = !collider.disabled
	LimboConsole.info("Noclip mode set to " + str(collider.disabled))



func view_distance(distance: int):
	camera.far = distance
	LimboConsole.info("View distance set to " + str(distance))

func god_mode():
	fly()
	noclip()
	fullbright()
	see(2)
	if camera.far == 100:
		view_distance(4000)
	else:
		view_distance(100)
