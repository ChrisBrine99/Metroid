/// @description An edited version of game maker's built-in audio_play_sound function that can stop the sound if
/// it is already playing as well as play the sound effect.
/// @param soundID
/// @param soundPriority
/// @param soundLoops
/// @param stopPrevious

var soundID, soundPriority, soundLoops, stopPrevious, sound;
soundID = argument0;
soundPriority = argument1;
soundLoops = argument2;
stopPrevious = argument3;
sound = -1;

// Stopping the sound from playing multiple times at once
if (stopPrevious){
	if (audio_is_playing(soundID)) {audio_stop_sound(soundID);}
}
// Play the sound and set its volume
sound = audio_play_sound(soundID, soundPriority, soundLoops);
audio_sound_gain(sound, scr_volume_type(soundID), 0);

return sound;