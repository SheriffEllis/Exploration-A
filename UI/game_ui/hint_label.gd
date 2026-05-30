class_name HintLabel extends Label

@onready var sound_type : AudioStreamPlayer = $TypewriterAudio
const CHAR_DELAY := 0.001
const CHAR_DELAY_VARIANCE := 0.1
var text_queue : Array[String] = []
var is_outputting := false
var queue_cancel := false

func _ready() -> void:
	Events.hint_triggered.connect(_on_hint_triggered)
	Events.hint_queue_cancelled.connect(_on_hint_queue_cancelled)
	#Events.dialogue_triggered.connect(_on_dialogue_triggered)

#func _on_dialogue_triggered(_input_text: String) -> void:
	#visible = false
#
#func _on_dialogue_queue_finished() -> void:
	#visible = true

func _on_hint_triggered(input_text: String) -> void: # FIXME triggered concurrently if dialogue is happening
	text_queue.append(input_text)
	if is_outputting: return
	is_outputting = true
	while not text_queue.is_empty():
		if not visible: 
			await Events.dialogue_queue_finished # Interrupted by dialogue
			#_on_dialogue_queue_finished()
			if text_queue.is_empty(): # text queue can be cancelled in interim of dialogue
				break 
		await display_text(text_queue.pop_front())
	is_outputting = false
	queue_cancel = false
	Events.hint_queue_finished.emit()


func _on_hint_queue_cancelled() -> void:
	text_queue = []
	if is_outputting:
		queue_cancel = true
	


func display_text(input_text: String) -> void:
	var output_text := ""
	var sound_count := 0
	for character : String in input_text:
		if not visible:
			await Events.dialogue_queue_finished # Interrupted by dialogue
			#_on_dialogue_queue_finished()
		if queue_cancel:
			text = ""
			queue_cancel = false
			return
		
		output_text = output_text + character
		text = output_text
		if sound_count < 3:
			sound_count += 1
		else:
			sound_type.play()
			sound_count = 0
		await get_tree().create_timer(CHAR_DELAY + randf()*CHAR_DELAY_VARIANCE*get_mouthfull_factor(), false).timeout # Time between letters
	await get_tree().create_timer(4.0 *get_mouthfull_factor(), false).timeout # Time to read before fading
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_pause_mode(Tween.TWEEN_PAUSE_BOUND)
	tween.tween_property(self, "modulate", Color(1,1,1,0), 1.0 * get_mouthfull_factor()) # Fade full sentence
	await tween.finished
	text = ""
	modulate = Color(1,1,1,1)

func get_mouthfull_factor() -> float:
	return 1.0/(0.5*text_queue.size()+1.0)
