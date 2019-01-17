/// @description Handling Looping Sounds
// You can write your code in this editor

if (instance_exists(obj_fade)){
	audio_stop_sound(snd_samus_run);
	return;	
}

// Playing the running sound
if (!crouching && !inMorphball){
	if ((left && hspd < -1) || (right && hspd > 1)){
		if (!audio_is_playing(snd_samus_run)){
			audio_play_sound(snd_samus_run, 0, true);
		}
	}
}
// Stopping the running sound
if (audio_is_playing(snd_samus_run)){
	if (!onGround || (hspd >= -1 && hspd <= 1) || crouching){
		audio_stop_sound(snd_samus_run);
	}
}