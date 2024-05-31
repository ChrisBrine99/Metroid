// Determine if the item fanfares should be loaded into memory or not by checking if the audio group isn't loaded
// into memory already AND that there are collectibles within the newly loaded room. If both of these conditions
// are revered, the audio group will be unloaded as it's no longer needed.
var _collectibleExists	= instance_exists(par_collectible);
var _fanfaresLoaded		= audio_group_is_loaded(music_fanfares);
if (_collectibleExists && !_fanfaresLoaded)
	audio_group_load(music_fanfares);
else if (!_collectibleExists && _fanfaresLoaded)
	audio_group_unload(music_fanfares);

// Calling each singleton's room start event, which handles code and logic that is required to be refreshed on a
// per-room basis. (Ex. the camera for each room needs to be initialized otherwise it won't function)
with(CAMERA)		{room_start();}

// Clear the flag that allows the map's room offset to be set so it can't be adjusted while in that room.
with(MAP_MANAGER)	{stateFlags &= ~MAP_SET_ROOM_OFFSET;}

// Don't bother with the room initialization code below this line if the current room is the initialization
// room because there will be no layers to match the onces that get turned invisible, and there is no way
// for there to be any dynamically created items in the room.
//if (room == rm_init) {return;}

// Make the two layers that shouldn't be visible to the player invisible upon the new room's startup.
//layer_set_visible(layer_get_id("Collision"), false);