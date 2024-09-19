// Don't run the code below this check if what was loaded wasn't the audio group containing Samus' intro fanfares.
if (ds_map_find_value(async_load, "group_id") != samus_fanfares)
	return;

// Call Samus' initialization function, but only after her required fanfare audio group has been loaded. Otherwise,
// the intro state could potentially be set BEFORE the intro theme played; allowing the player to quickly press 
// either the left or right inputs to switch to Samus' default state prematurely.
initialize(state_intro);
audio_play_sound(mus_samus_intro1, 0, false);