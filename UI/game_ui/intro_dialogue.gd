extends RichTextLabel

func _ready() -> void:
	Events.intro_cutscene_started.connect(_on_intro_cutscene_started)
	Events.intro_cutscene_ended.connect(_on_intro_cutscene_ended)

func _on_intro_cutscene_started() -> void:
	await display_intro_dialogue()

func _on_intro_cutscene_ended() -> void:
	await end_intro_cutscene()

func display_intro_dialogue() -> void:
	await get_tree().create_timer(2, false).timeout
	$DialogueAudio.play()
	text = "[color=#59ff93]Really Navi, in front of our guests?\n Are you [i]trying[/i] to torment me?[/color]"
	Events.append_text_history.emit(text)
	await get_tree().create_timer(7, false).timeout
	#text = "[color=#59ff93]It's like you're [i]trying[/i] to torment me.[/color]"
	#Events.append_text_history.emit(text)
	#await get_tree().create_timer(4, false).timeout
	text = "[color=#ffee58]Do you expect me to pretend it's not there?[/color]"
	Events.append_text_history.emit(text)
	await get_tree().create_timer(2.5, false).timeout
	text = "[color=#59ff93]Enough, I'm sick of this.[/color]"
	Events.append_text_history.emit(text)
	await get_tree().create_timer(1.3, false).timeout
	text = "[color=#ffee58]I've got to do [i]something[/i] about it.[/color]"
	Events.append_text_history.emit(text)
	await get_tree().create_timer(2.5, false).timeout
	text = "[color=#59ff93]Go sleep on the couch with your [i]beloved hallway.[/i][/color]"
	Events.append_text_history.emit(text)
	await $DialogueAudio.finished
	text = ""
	var tween := create_tween()
	tween.tween_property($"..", "color", Color(), 1.0)
	await tween.finished
	await get_tree().create_timer(2, false).timeout
	Events.intro_cutscene_ended.emit()

func end_intro_cutscene() -> void:
	$"../../HUD".visible = true
	GameGlobals.player.process_mode = Node.PROCESS_MODE_INHERIT
	var tween := create_tween()
	tween.tween_property($"..", "color", Color(0,0,0,0), 0.5)
	await tween.finished
	$"..".queue_free()
