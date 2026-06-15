extends Area3D

@export var extended_range := 40.0
@export var extended_attenuation := 0.8
@export var transition_time := 1.0
var initial_range : float
var initial_attenuation : float

func _ready() -> void:
	initial_range = GameGlobals.player.flashlight.spot_range
	initial_attenuation = GameGlobals.player.flashlight.spot_attenuation

func _on_body_entered() -> void:
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(GameGlobals.player.flashlight, "spot_range", extended_range, transition_time)
	tween.tween_property(GameGlobals.player.flashlight, "spot_attenuation", extended_attenuation, transition_time)
	#GameGlobals.player.flashlight.spot_range = extended_range


func _on_body_exited() -> void:
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(GameGlobals.player.flashlight, "spot_range", initial_range, transition_time)
	tween.tween_property(GameGlobals.player.flashlight, "spot_attenuation", initial_attenuation, transition_time)
	#GameGlobals.player.flashlight.spot_range = initial_range
