extends Area3D

var is_player_inside := false
var is_player_looking := false
var is_flashlight_on := false

func _ready() -> void:
	Events.flashlight_turned_on.connect(_on_flashlight_turned_on)
	Events.flashlight_turned_off.connect(_on_flashlight_turned_off)

func _on_body_entered(_body: Node3D) -> void:
	is_player_inside = true
	validate()

func _on_body_exited(_body: Node3D) -> void:
	is_player_inside = false


func _on_flashlight_turned_on() -> void:
	is_flashlight_on = true
	validate()

func _on_flashlight_turned_off() -> void:
	is_flashlight_on = false


func _on_picture_reminder_requirement_screen_entered() -> void:
	is_player_looking = true
	validate()

func _on_picture_reminder_requirement_screen_exited() -> void:
	is_player_looking = false


func validate() -> void:
	if is_player_inside and is_player_looking and is_flashlight_on:
		Events.dialogue_triggered.emit("I need to keep this door visible somehow.")
		Events.hint_triggered.emit("[Camera can be raised/lowered with RMB]")
		Events.hint_triggered.emit("[Images of objects can be captured with LMB]")
		queue_free()
