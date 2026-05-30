class_name PauseMenu
extends Control

signal paused
signal resumed

const ACTION_PAUSE: StringName = &"ui_cancel"

var can_pause: bool = true
var pause_override: bool = false # Allow pause to be disabled entirely by debug tools
var is_paused: bool = false: set = set_paused


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT and (not is_paused) and GameGlobals.player.camera.current:
		pause()


func _input(event: InputEvent) -> void:
	if not event.is_action_pressed(ACTION_PAUSE):
		return

	if is_paused:
		resume()
	elif can_pause:
		pause()
	else:
		# lets the game be paused next time pause key pressed
		# prevents escape event being read twice
		can_pause = true


func set_paused(new_value: bool) -> void:
	is_paused = new_value
	get_tree().paused = new_value


func resume() -> void:
	# Recapture the mouse when escape pressed on pause menu
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_paused(false)
	hide()
	resumed.emit()
	Events.resumed.emit()


func pause() -> void:
	if pause_override:
		return

	# Allow the mouse to be moved when paused
	#_previous_mouse_mode = Input.mouse_mode
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	show()
	set_paused(true)
	paused.emit()
	Events.paused.emit()


func _on_quit_pressed() -> void:
	get_tree().quit()
