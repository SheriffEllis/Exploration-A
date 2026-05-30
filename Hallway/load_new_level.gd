extends Area3D

@export_file("*.tscn") var new_level := "res://Hallway/"
@export var old_node_name := "Hallway0"
@export var new_location := Vector3.ZERO


func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)


func _on_body_entered(_body: Node3D) -> void:
	Events.flicker_triggered.emit()
	await Events.flashlight_turned_off
	GameGlobals.player.flashlight.visible = false
	GameGlobals.LEVEL.load_new_level(new_level, old_node_name, new_location)
	await Events.level_loaded
	GameGlobals.player.flashlight.visible = true
