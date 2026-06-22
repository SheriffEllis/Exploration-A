extends Node
@warning_ignore_start("unused_signal")

signal level_ready
signal level_loaded
signal paused
signal resumed

signal floor_changed(new_sound: AudioStream)
signal cam_cull_mask_changed(layer_num: int, new_value: bool)
signal flashlight_turned_on
signal flashlight_turned_off
signal flicker_triggered
signal image_captured
signal image_deleted
signal forced_image_deletion

#region
signal intro_cutscene_started
signal intro_cutscene_ended
signal interaction_prompted
signal camcorder_collected
signal flashlight_collected
signal key_collected(key_id: int)
#endregion

#region
signal hint_triggered(text: String)
signal dialogue_triggered(text: String)
signal append_text_history(text: String)
signal hint_queue_finished()
signal dialogue_queue_finished()
signal all_text_queues_finished()
signal hint_queue_cancelled()
signal dialogue_queue_cancelled()
#endregion

@warning_ignore_restore("unused_signal")
