extends RichTextLabel

func _ready() -> void:
	Events.hint_triggered.connect(_on_hint_triggered)
	Events.dialogue_triggered.connect(_on_dialogue_triggered)

func _on_hint_triggered(new_text: String) -> void:
	append_text(new_text+"\n")

func _on_dialogue_triggered(new_text: String) -> void:
	append_text("[color=#ffee58]"+new_text+"[/color]\n")
