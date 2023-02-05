// Calling each singleton's room start event, which handles code and logic that is required to be refreshed on a
// per-room basis. (Ex. the camera for each room needs to be initialized otherwise it won't function)
with(CAMERA)		{room_start();}

// Don't bother with the room initialization code below this line if the current room is the initialization
// room because there will be no layers to match the onces that get turned invisible, and there is no way
// for there to be any dynamically created items in the room.
//if (room == rm_init) {return;}

// Make the two layers that shouldn't be visible to the player invisible upon the new room's startup.
//layer_set_visible(layer_get_id("Collision"), false);