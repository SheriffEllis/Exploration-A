extends RichTextLabel

var interrupted := false

func _ready() -> void:
	Events.intro_cutscene_started.connect(_on_intro_cutscene_started)
	Events.intro_cutscene_ended.connect(_on_intro_cutscene_ended)

func _on_intro_cutscene_started() -> void:
	await display_intro_dialogue()

func _on_intro_cutscene_ended() -> void:
	await end_intro_cutscene()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("jump"): skip_intro_cutscene()

func display_intro_dialogue() -> void:
	await get_tree().create_timer(2, false).timeout
	if interrupted: return # find a better way to do this in the future
	$DialogueAudio.play()
	text = "[color=#59ff93]Really Navi, in front of our guests?\n Are you [i]trying[/i] to torment me?[/color]"
	Events.append_text_history.emit(text)
	await get_tree().create_timer(7, false).timeout
	if interrupted: return
	text = "[color=#ffee58]Do you expect me to pretend it's not there?[/color]"
	Events.append_text_history.emit(text)
	await get_tree().create_timer(2.5, false).timeout
	if interrupted: return
	text = "[color=#59ff93]Enough, I'm sick of this.[/color]"
	Events.append_text_history.emit(text)
	await get_tree().create_timer(1.3, false).timeout
	if interrupted: return
	text = "[color=#ffee58]I've got to do [i]something[/i] about it.[/color]"
	Events.append_text_history.emit(text)
	await get_tree().create_timer(2.5, false).timeout
	if interrupted: return
	text = "[color=#59ff93]Go sleep on the couch with your [i]beloved hallway.[/i][/color]"
	Events.append_text_history.emit(text)
	await $DialogueAudio.finished
	text = ""
	var tween := create_tween()
	tween.tween_property($"..", "color", Color(), 1.0) # Fade to black
	await tween.finished
	await get_tree().create_timer(2, false).timeout
	Events.intro_cutscene_ended.emit()

func skip_intro_cutscene() -> void:
	interrupted = true
	text = ""
	var tween_dark := create_tween()
	tween_dark.tween_property($"..", "color", Color(), 0.5) # Fade to black
	var tween_sound := create_tween()
	tween_sound.tween_property($DialogueAudio, "volume_linear", 0.0, 0.5) # Fade out sound of dialogue
	await tween_sound.finished
	Events.intro_cutscene_ended.emit()
	

func end_intro_cutscene() -> void:
	$"../../HUD".visible = true
	GameGlobals.player.process_mode = Node.PROCESS_MODE_INHERIT
	var tween := create_tween()
	tween.tween_property($"..", "color", Color(0,0,0,0), 0.5) # Fade out of black
	await tween.finished
	$"..".queue_free()
