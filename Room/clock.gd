extends MeshInstance3D

@onready var timer : Timer = $Timer
@onready var hour_hand : MeshInstance3D = $HourHand
@onready var minute_hand : MeshInstance3D = $MinuteHand
@onready var second_hand : MeshInstance3D = $SecondHand

const TICK = PI/30.0

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	second_hand.rotate_y(TICK)
	minute_hand.rotate_y(TICK/60.0)
	hour_hand.rotate_y(TICK/360.0)
