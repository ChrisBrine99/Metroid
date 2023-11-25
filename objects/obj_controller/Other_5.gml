// Unloads all of the non-persistent light sources from memory before moving onto the next room.
effect_unload_room_lighting();

// Unloads the audio group that stores all item acquisition fanfares upon moving to the next room. This ensures
// that if these songs were loaded into memory within the current room, they will remain loaded for further use
// until a room transition occurs.
if (audio_group_is_loaded(music_fanfares))
	audio_group_unload(music_fanfares);