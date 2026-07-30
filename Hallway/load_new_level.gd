class_name LevelLoader extends Node

@export var next_level_index := -1
@export var old_level_root : Node3D

enum TransitionType{
	FLICKER,
	FADE_IN,
	NONE
}
@export var transition_type := TransitionType.FLICKER

func trigger() -> void:
	if transition_type == TransitionType.FLICKER:
		Events.flicker_triggered.emit()
		await Events.flashlight_turned_off
	GameGlobals.player.flashlight.visible = false
	GameGlobals.LEVEL.load_new_level(GameGlobals.LEVELS[next_level_index], old_level_root.name)
	await Events.level_loaded
	GameGlobals.player.flashlight.visible = true
	if transition_type == TransitionType.FADE_IN:
		var tween := get_tree().create_tween().bind_node(GameGlobals.player) # can't be bound to self as this will be deleted after scene change
		tween.tween_property(GameGlobals.player.flashlight, "light_energy", 1, 1)
	else:
		GameGlobals.player.flashlight.light_energy = 1
