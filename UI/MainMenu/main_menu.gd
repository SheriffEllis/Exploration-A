extends Control

var MAIN_LEVEL : PackedScene = preload("uid://botkc1uivwekw")
@export var load_button : Button

func _ready() -> void:
	if not FileAccess.file_exists("user://house.save"):
		load_button.disabled = true


func _on_begin_pressed() -> void:
	GameGlobals.load_saved_game = false
	get_tree().change_scene_to_packed(MAIN_LEVEL)


func _on_load_pressed() -> void:
	GameGlobals.load_saved_game = true
	get_tree().change_scene_to_packed(MAIN_LEVEL)


func _on_exit_pressed() -> void:
	get_tree().quit()
