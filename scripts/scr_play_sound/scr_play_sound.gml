/// @description An edited version of game maker's built-in audio_play_sound function that can stop the sound if
/// it is already playing as well as play the sound effect.
/// @param soundId
/// @param soundPriority
/// @param soundLoops
/// @param stopPrevious

var soundId, soundPriority, soundLoops, stopPrevious;
soundId = argument0;
soundPriority = argument1;
soundLoops = argument2;
stopPrevious = argument3;

// Stopping the sound from playing multiple times at once
if (stopPrevious){
	if (audio_is_playing(soundId)) {audio_stop_sound(soundId);}
}
// Play the sound
audio_play_sound(soundId, soundPriority, soundLoops);