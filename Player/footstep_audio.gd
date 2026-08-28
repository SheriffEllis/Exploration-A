extends AudioStreamPlayer3D

@export var footstep_frequency := 1.0

var footstep_time := 0.0
var footstep_can_play := false
var footstep_landed := true

var prev_velocity := Vector3.ZERO

func _ready() -> void:
	Events.floor_changed.connect(change_sfx)

func change_sfx(new_sound: AudioStream):
	stream = new_sound

func handle_footstep(player: PlayerCharacter, delta: float, headbob_amplitude: float = 1.0) -> void:
	footstep_time += delta * player.velocity.length() * float(player.is_on_floor())
	
	var headbob_position = Vector3.ZERO
	headbob_position.y = sin(footstep_time * footstep_frequency) * headbob_amplitude
	#headbob_position.x = cos(footstep_time * footstep_frequency / 2) * headbob_amplitude
	
	var footstep_threshold = -headbob_amplitude + 0.05
	if headbob_position.y > footstep_threshold:
		footstep_can_play = true
	elif headbob_position.y < footstep_threshold and footstep_can_play:
		footstep_can_play = false
		play()
	
	if not $LandingCooldown.is_stopped(): return
	if not footstep_landed and player.is_on_floor():
		if abs(prev_velocity.y) > 5.0:
			$StumbleAudio.volume_db = abs(prev_velocity.y)
			$StumbleAudio.play()
		else:
			play()
		$LandingCooldown.start()
	elif footstep_landed and not player.is_on_floor():
		play()
	footstep_landed = player.is_on_floor()
	set_deferred("prev_velocity", player.velocity)
