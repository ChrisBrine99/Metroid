// 
if (ds_map_find_value(async_load, "group_id") != samus_fanfares)
	return;

// 
initialize(state_intro);
entity_set_position(480, 336);
audio_play_sound(mus_samus_intro1, 0, false);