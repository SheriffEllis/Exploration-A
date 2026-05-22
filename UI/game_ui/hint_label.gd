class_name HintLabel extends Label

@onready var sound_type : AudioStreamPlayer = $TypewriterAudio
const CHAR_DELAY := 0.001
const CHAR_DELAY_VARIANCE := 0.1
var text_queue : Array[String] = []
var is_outputting := false

func _ready() -> void:
	Events.hint_triggered.connect(_on_hint_triggered)

func _on_hint_triggered(input_text: String) -> void:
	text_queue.append(input_text)
	if is_outputting: return
	while not text_queue.is_empty():
		await display_text(text_queue.pop_front())
	Events.hint_queue_finished.emit()

func display_text(input_text: String) -> void:
	is_outputting = true
	var output_text := ""
	var sound_count := 0
	for character : String in input_text:
		output_text = output_text + character
		text = output_text
		if sound_count < 3:
			sound_count += 1
		else:
			sound_type.play()
			sound_count = 0
		await get_tree().create_timer(CHAR_DELAY + randf()*CHAR_DELAY_VARIANCE*get_mouthfull_factor()).timeout
		if get_tree().paused:
			await Events.resumed
	await get_tree().create_timer(4.0 *get_mouthfull_factor()).timeout
	if get_tree().paused:
		await Events.resumed
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "modulate", Color(1,1,1,0), 1.0 * get_mouthfull_factor())
	await tween.finished
	text = ""
	modulate = Color(1,1,1,1)
	is_outputting = false

func get_mouthfull_factor() -> float:
	return 1.0/(text_queue.size()+1.0)
