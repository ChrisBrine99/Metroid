#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();
// Set the overall time that the block will remain "destroyed" for to the value determined in the macro and the
// sprite index to match what it is in the object editor, which is only set to make it easy to place in rooms.
timeToRespawn = RESPAWN_TIMER_GENERAL;
sprite_index = spr_destructible_all;

#endregion