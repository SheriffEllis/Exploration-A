class_name Level extends Node3D

@export var skip_intro := false
@export var starting_location : Vector3
@export var starting_rotation : Vector3
@export var starting_level : int

var interact_pressed := false
var last_safe_location := Vector3.ZERO

var current_loading_scene := ""
var current_node_to_delete := ""
var new_starting_location := Vector3.ZERO

func _ready() -> void:
	GameGlobals.LEVEL = self
	GameGlobals.GAME_UI = $GameUI
	GameGlobals.ENVIRONMENT = $AmbienceManager/WorldEnvironment
	GameGlobals.player = $Player
	Events.level_ready.emit()
	
	if starting_level > 0:
		match(starting_level):
			1: load_new_level("uid://bnsblodj1ihor", "Hallway0", starting_location)
			2: load_new_level("uid://d0jdxlkx5i67m", "Hallway0", starting_location)
			3: load_new_level("uid://bku8imjjwm262", "Hallway0", starting_location)
		if starting_level > 1:
			GameGlobals.player.flashlight.light_color = Color("#FFFFFF")
		Events.hint_triggered.emit("[Loaded Level " + str(starting_level) + "]")
	
	if starting_location:
		# Tutorial 2: -27.0, 0, 50
		GameGlobals.player.global_position = starting_location
		last_safe_location = starting_location
	
	if starting_level > 0 or starting_location:
		remove_house()
		$AmbienceManager._on_area_3d_room_body_exited(null)
	
	if starting_rotation:
		GameGlobals.player.rotation_degrees = starting_rotation
	
	if skip_intro:
		Events.intro_cutscene_ended.emit()
		Events.camcorder_collected.emit()
		Events.flashlight_collected.emit()
		GameGlobals.player.flashlight.visible = true
		Events.key_collected.emit(1)
		GameGlobals.GAME_UI.hint_label.text_queue = []
		GameGlobals.GAME_UI.dialogue_label.text_queue = []
		if not starting_location and not starting_rotation:
			GameGlobals.player.global_transform = $Room/DefaultStartingLocation.global_transform
		Events.hint_triggered.emit("[Intro Skipped]")
		return
	
	Events.camcorder_collected.connect(_on_interact_pressed)
	Events.flashlight_collected.connect(_on_interact_pressed)
	
	# TODO: intro argument cutscene
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


func _on_interact_pressed() -> void:
	interact_pressed = true


func remove_house() -> void:
	$Room.queue_free()
	$Outside.queue_free()


func restore_house() -> void:
	add_child(load("uid://c28hmcs10hs0h").instantiate()) # Room
	add_child(load("uid://c2kbweneknqnu").instantiate()) # Outside


func load_new_level(sceneDir : String, old_level_node_name: String, new_location:= Vector3.ZERO) -> void:
	ResourceLoader.load_threaded_request(sceneDir)
	current_loading_scene = sceneDir
	current_node_to_delete = old_level_node_name
	new_starting_location = new_location


func _process(_delta: float) -> void:
	if current_loading_scene.is_empty(): return
	var scene_load_status := ResourceLoader.load_threaded_get_status(current_loading_scene)
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var new_scene := ResourceLoader.load_threaded_get(current_loading_scene)
		get_node(current_node_to_delete).queue_free()
		current_node_to_delete = ""
		add_child(new_scene.instantiate())
		GameGlobals.player.global_position = new_starting_location
		last_safe_location = new_starting_location
		
		Events.level_loaded.emit()
		current_loading_scene = ""
