class_name Level extends Node3D

@export var skip_intro := false
@export var start_position_override : Vector3
@export var start_rotation_override : Vector3
@export var starting_level : int

var interact_pressed := false
var last_safe_position := Vector3.ZERO

var current_loading_scene := ""
var current_node_to_delete := ""
var new_starting_location := Vector3.ZERO

func _ready() -> void:
	GameGlobals.LEVEL = self
	GameGlobals.GAME_UI = $GameUI
	GameGlobals.ENVIRONMENT = $AmbienceManager/WorldEnvironment
	GameGlobals.player = $Player
	if GameGlobals.load_saved_game: load_game()
	Events.level_ready.emit()
	
	if starting_level != 0 or start_position_override:
		remove_house()
		$AmbienceManager._on_area_3d_room_body_exited(null)
	
	if starting_level != 0:
		GameGlobals.player.flashlight.visible = false
		load_new_level(GameGlobals.LEVELS[starting_level], "Hallway0")
		
		if starting_level > 1 or starting_level < 0:
			GameGlobals.player.flashlight.light_color = Color("#FFFFFF")
		Events.hint_triggered.emit("[Loaded Level " + str(starting_level) + "]")
	
	if start_position_override:
		# Tutorial 2: -27.0, 0, 50
		GameGlobals.player.global_position = start_position_override
		last_safe_position = start_position_override
	
	if start_rotation_override:
		GameGlobals.player.rotation_degrees = start_rotation_override
		start_rotation_override = Vector3()
	
	if skip_intro:
		Events.intro_cutscene_ended.emit()
		Events.camcorder_collected.emit()
		Events.flashlight_collected.emit()
		GameGlobals.player.flashlight.light_energy = 0
		await get_tree().create_timer(0.1, false).timeout
		GameGlobals.player.flashlight.visible = true
		var tween := create_tween()
		tween.tween_property(GameGlobals.player.flashlight, "light_energy", 1, 0.5)
		
		Events.key_collected.emit(1)
		GameGlobals.GAME_UI.hint_label.text_queue = []
		GameGlobals.GAME_UI.dialogue_label.text_queue = []
		if has_node("Room/DefaultStartingLocation"): # not start_position_override and not start_rotation_override and starting_level == 0:
			GameGlobals.player.global_transform = $Room/DefaultStartingLocation.global_transform
		#Events.hint_triggered.emit("[Intro Skipped]")
		return
	
	intro_tutorial()


func load_game() -> void:
	if not FileAccess.file_exists("user://house.save"):
		return
	
	var save_file = FileAccess.open("user://house.save", FileAccess.READ)
	var json_string = save_file.get_line()
	save_file.close()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		push_error("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return

	var data : Dictionary = json.data
	starting_level = data["starting_level"]
	#start_position_override = Vector3(data["start_pos_x"], data["start_pos_y"], data["start_pos_z"])
	#start_rotation_override = Vector3(data["start_rot_x"], data["start_rot_y"], data["start_rot_z"])
	skip_intro = true


func save_game(hallway : HallwayLevel) -> void:
	var save_file := FileAccess.open("user://house.save", FileAccess.WRITE)
	var data := {
		"starting_level" : hallway.level_index,
	}
	var json_string := JSON.stringify(data)
	save_file.store_line(json_string)
	Events.hint_triggered.emit("[Progress Saved.]")


func _on_interact_pressed() -> void:
	interact_pressed = true


func intro_tutorial() -> void:
	Events.camcorder_collected.connect(_on_interact_pressed)
	Events.flashlight_collected.connect(_on_interact_pressed)
	Events.intro_cutscene_started.emit()
	await Events.intro_cutscene_ended
	GameGlobals.player.global_transform = $Room/DefaultStartingLocation.global_transform
	
	await get_tree().create_timer(2, false).timeout
	Events.dialogue_triggered.emit("There's no chance in hell I'm getting any sleep like this.")
	Events.dialogue_triggered.emit("Call me impetuous or just curious,")
	Events.dialogue_triggered.emit("But a little look around that hallway isn't going to hurt.")
	Events.hint_triggered.emit("[Press X to Look Closely]")
	Events.hint_triggered.emit("[Press ESC to Pause and reread hints]")
	await Events.all_text_queues_finished
	
	await get_tree().create_timer(10, false).timeout
	if not interact_pressed:
		Events.dialogue_triggered.emit("I should gather my equipment from the table before I go in.")
		await get_tree().create_timer(4, false).timeout
		if not interact_pressed:
			Events.hint_triggered.emit("[Press E to Interact]")
			Events.interaction_prompted.emit()


func remove_house() -> void:
	$Room.queue_free()
	$Outside.queue_free()


func restore_house() -> void:
	add_child(load("uid://c28hmcs10hs0h").instantiate()) # Room
	add_child(load("uid://c2kbweneknqnu").instantiate()) # Outside


func load_new_level(sceneDir : String, old_level_node_name: String) -> void:
	ResourceLoader.load_threaded_request(sceneDir)
	current_loading_scene = sceneDir
	current_node_to_delete = old_level_node_name


func _process(_delta: float) -> void:
	if current_loading_scene.is_empty(): return
	var scene_load_status := ResourceLoader.load_threaded_get_status(current_loading_scene)
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var new_scene := ResourceLoader.load_threaded_get(current_loading_scene)
		get_node(current_node_to_delete).queue_free()
		current_node_to_delete = ""
		var new_hallway : HallwayLevel = new_scene.instantiate()
		add_child(new_hallway)
		if new_hallway.starting_location and not start_position_override:
			GameGlobals.player.global_transform = new_hallway.starting_location.global_transform
		elif not start_position_override:
			GameGlobals.player.global_transform = Transform3D()
		else:
			start_position_override = Vector3()
			start_rotation_override = Vector3()
		last_safe_position = GameGlobals.player.global_position
		if GameGlobals.load_saved_game:
			GameGlobals.load_saved_game = false
		else:
			save_game(new_hallway)
		Events.level_loaded.emit()
		current_loading_scene = ""
