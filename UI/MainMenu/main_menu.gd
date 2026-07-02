extends Control

var MAIN_LEVEL : PackedScene = preload("uid://botkc1uivwekw")


func _on_begin_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN_LEVEL)


func _on_exit_pressed() -> void:
	get_tree().quit()
