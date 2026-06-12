extends Area3D

@export var extended_range := 40.0
@export var transition_time := 1.0
var initial_range : float

func _ready() -> void:
	initial_range = GameGlobals.player.flashlight.spot_range

func _on_body_entered() -> void:
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(GameGlobals.player.flashlight, "spot_range", extended_range, transition_time)
	#GameGlobals.player.flashlight.spot_range = extended_range


func _on_body_exited() -> void:
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(GameGlobals.player.flashlight, "spot_range", initial_range, transition_time)
	#GameGlobals.player.flashlight.spot_range = initial_range
