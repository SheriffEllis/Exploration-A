extends Control

var entry_level := preload("uid://botkc1uivwekw")


func _on_begin_pressed() -> void:
	get_tree().change_scene_to_packed(entry_level)


func _on_exit_pressed() -> void:
	get_tree().quit()
