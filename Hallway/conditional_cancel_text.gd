extends CancelText

func _on_body_entered(_body: Node3D) -> void:
	if GameGlobals.GAME_UI.hint_label.text_queue.size() > 0 or GameGlobals.GAME_UI.dialogue_label.text_queue.size() > 0:
		super(_body)
