// Completely removing any instances of destructible objects that have infinite respawn timers. They are infinie
// in the sense that once the block has been destroyed, it will remain destroyed for the duration of the room's
// existence. Once the player leaves the room, these blocks will finally respawn.
if (ENTT_IS_DESTROYED && timeToRespawn == DEST_RESPAWN_INFINITE && effectID == noone) 
	instance_destroy_object(id);