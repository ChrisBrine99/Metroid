/// @description Insert description here
// You can write your code in this editor

switch(setIndex){
	case 1: // Powerbeam explosion
		sprite_index = spr_missile_explode;
		// Stop the sound from overlapping
		if (audio_is_playing(snd_missile_explode)) audio_stop_sound(snd_missile_explode);
		audio_play_sound(snd_missile_explode, 0, false);
		break;
	case 2: // Icebeam explosion
		sprite_index = spr_sMissile_explode;
		// Stop the sound from overlapping
		if (audio_is_playing(snd_sMissile_explode)) audio_stop_sound(snd_sMissile_explode);
		audio_play_sound(snd_sMissile_explode, 0, false);
		break;
}
mask_index = sprite_index;