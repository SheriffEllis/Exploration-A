class_name PlayerScreenUI
extends Node

const ACTION_INVENTORY: StringName = &"inventory"
const ACTION_CLOSE: StringName = &"ui_cancel"

@export var crosshair: AnimatedSprite2D
@export var fps_counter: Label
@export var pause_menu: Panel

var paused: bool = false: set = set_paused
var can_pause: bool = true
var pause_override: bool = false # Allow pause to be disabled entirely by debug tools
#var _previous_mouse_mode := Input.MouseMode.MOUSE_MODE_CAPTURED


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		pause()


func _process(_delta: float) -> void:
	if fps_counter.visible:
		fps_counter.text = str("FPS: ", Engine.get_frames_per_second())


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(ACTION_INVENTORY) and not paused:
		GameGlobals.meta_level.game_ui.toggle_inventory(null)
		return
	
	if not event.is_action_pressed(ACTION_CLOSE):
		return
	
	if paused:
		resume()
	elif can_pause:
		pause()
	else:
		# lets the game be paused next time pause key pressed
		# prevents escape event being read twice
		can_pause = true


func set_paused(new_value: bool) -> void:
	paused = new_value
	get_tree().paused = new_value


func resume() -> void:
	# Recapture the mouse when escape pressed on pause menu
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)#_previous_mouse_mode)
	pause_menu.visible = false
	paused = false


func pause() -> void:
	if pause_override:
		return

	# Allow the mouse to be moved when paused
	#_previous_mouse_mode = Input.mouse_mode
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pause_menu.visible = true
	paused = true
	Events.paused.emit()


# emitted by Player
func _on_player_interaction_cursor_changed(is_in_range: bool) -> void:
	crosshair.frame = int(is_in_range)


func _on_resume_pressed() -> void:
	resume()


func _on_quit_pressed() -> void:
	get_tree().quit()
