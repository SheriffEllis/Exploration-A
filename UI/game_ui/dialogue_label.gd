class_name DialogueLabel extends Label

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
	while not text_queue.is_empty():
		await display_text(text_queue.pop_front())
	is_outputting = false
	Events.dialogue_queue_finished.emit()

func _on_dialogue_queue_cancelled() -> void:
	text_queue = []
	if is_outputting:
		queue_cancel = true

func display_text(input_text: String) -> void:
	text = input_text
	sound_speak.play()
	await sound_speak.finished
	if queue_cancel:
		text = ""
		queue_cancel = false
		return
	await get_tree().create_timer(4.0 *get_mouthfull_factor()).timeout
	if get_tree().paused:
		await Events.resumed
	if queue_cancel:
		text = ""
		queue_cancel = false
		return
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "modulate", Color(1,1,1,0), 1.0 * get_mouthfull_factor())
	await tween.finished
	text = ""
	modulate = Color(1,1,1,1)

func get_mouthfull_factor() -> float:
	return 1.0/(text_queue.size()+1.0)
