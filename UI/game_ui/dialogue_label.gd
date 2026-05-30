class_name DialogueLabel extends Label

const SPEECH_SPEED_FACTOR := 20.0
const SOUND_LENGTH := 2.0
@onready var sound_speak : AudioStreamPlayer = $DialogueAudio
var text_queue : Array[String] = []
var is_outputting := false
var queue_cancel := false

func _ready() -> void:
	Events.dialogue_triggered.connect(_on_dialogue_triggered)
	Events.dialogue_queue_cancelled.connect(_on_dialogue_queue_cancelled)

func _on_dialogue_triggered(input_text: String) -> void:
	text_queue.append(input_text)
	if is_outputting: return
	is_outputting = true
	GameGlobals.GAME_UI.hint_label.visible = false
	#GameGlobals.GAME_UI.hint_label.process_mode = Node.PROCESS_MODE_DISABLED
	while not text_queue.is_empty():
		await display_text(text_queue.pop_front())
	is_outputting = false
	queue_cancel = false
	GameGlobals.GAME_UI.hint_label.visible = true
	#GameGlobals.GAME_UI.hint_label.process_mode = Node.PROCESS_MODE_PAUSABLE
	Events.dialogue_queue_finished.emit()

func _on_dialogue_queue_cancelled() -> void:
	text_queue = []
	if is_outputting:
		queue_cancel = true

func display_text(input_text: String) -> void:
	text = input_text
	var start_pos := SOUND_LENGTH*get_speech_speed()*get_speech_speed()
	sound_speak.play(start_pos)
	await sound_speak.finished
	if queue_cancel:
		text = ""
		queue_cancel = false
		return
	await get_tree().create_timer(3.0*(1-clampf(get_speech_speed()*get_speech_speed()/get_mouthfull_factor(), 0, 1)), false).timeout
	#if get_tree().paused:
		#await Events.resumed
	if queue_cancel:
		text = ""
		queue_cancel = false
		return
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_pause_mode(Tween.TWEEN_PAUSE_STOP)
	tween.tween_property(self, "modulate", Color(1,1,1,0), 1.0 * get_mouthfull_factor())
	await tween.finished
	text = ""
	queue_cancel = false
	modulate = Color(1,1,1,1)

func get_mouthfull_factor() -> float:
	return 1.0/(0.5*text_queue.size()+1.0)

func get_speech_speed() -> float:
	return 1.0/((1/SPEECH_SPEED_FACTOR)*text.length()+1.0)
