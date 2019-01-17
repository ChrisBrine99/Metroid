/// @description Give the player 5 energy.
// You can write your code in this editor

if (hasCollided){
	// Play the health pickup sound
	audio_play_sound(snd_health_pickup, 1, false);
	scr_update_energy(5);
}