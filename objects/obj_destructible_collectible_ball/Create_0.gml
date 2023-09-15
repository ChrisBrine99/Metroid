#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();
// Set the overall time that the block will remain "destroyed" for to the value determined in the macro and the
// sprite index to match what it is in the object editor, which is only set to make it easy to place in rooms.
timeToRespawn	= DEST_RESPAWN_INFINITE;
sprite_index	= spr_destructible_collectible_ball;
// Prevent the collectible ball from creating the destruction effect when it's destroyed by the player.
stateFlags	   &= ~DEST_USE_EFFECTS;

#endregion