// Unloads all of the non-persistent light sources from memory before moving onto the next room.
effect_unload_room_lighting();

// Flip the flag that allows the map manager to update the x and y positions for the room that is being loaded.
with(MAP_MANAGER)	{stateFlags |= MAP_SET_ROOM_OFFSET;}