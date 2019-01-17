/// @description Give the player 2 missiles.
// You can write your code in this editor

if (hasCollided){
	// Play the ammo pickup sound
	audio_play_sound(snd_ammo_pickup, 1, false);
	global.missiles += 2;
	if (global.missiles > global.missilesMax){
		global.missiles = global.missilesMax;	
	}
}