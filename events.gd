extends Node
@warning_ignore_start("unused_signal")

signal level_ready
signal paused

signal floor_changed(new_sound: AudioStream)
signal cam_cull_mask_changed(layer_num: int, new_value: bool)
signal flashlight_turned_on
signal flashlight_turned_off

#region
signal camcorder_collected
signal flashlight_collected
signal key_collected(key_id: int)
#endregion

signal flicker_triggered

@warning_ignore_restore("unused_signal")
