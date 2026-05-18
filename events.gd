extends Node
@warning_ignore_start("unused_signal")

signal level_ready
signal paused
signal floor_changed(new_sound: AudioStream)

@warning_ignore_restore("unused_signal")
