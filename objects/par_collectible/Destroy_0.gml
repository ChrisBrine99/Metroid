// Perform a check to see if this is the last remaining collectible in the room. If so, the audio group storing
// item collection fanfares will be unloaded from memory. Otherwise, it will remain loaded for other items.
instance_activate_object(par_collectible);
if (instance_number(par_collectible) == 1)
	audio_group_unload(music_fanfares);