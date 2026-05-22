extends Node
@warning_ignore_start("unused_signal")

signal level_ready
signal paused
signal resumed

signal floor_changed(new_sound: AudioStream)
signal cam_cull_mask_changed(layer_num: int, new_value: bool)
signal flashlight_turned_on
signal flashlight_turned_off
signal image_captured
signal image_deleted

#region
signal camcorder_collected
signal flashlight_collected
signal key_collected(key_id: int)
#endregion

signal flicker_triggered
signal hint_triggered(text: String)
signal dialogue_triggered(text: String)
signal hint_queue_finished()

@warning_ignore_restore("unused_signal")
