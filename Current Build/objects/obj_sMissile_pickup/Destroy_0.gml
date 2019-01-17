/// @description Give the player 1 super missile.
// You can write your code in this editor

if (hasCollided){
	// Play the ammo pickup sound
	audio_play_sound(snd_ammo_pickup, 1, false);
	global.sMissiles++;
	if (global.sMissiles > global.sMissilesMax){
		global.sMissiles = global.sMissilesMax;	
	}
}