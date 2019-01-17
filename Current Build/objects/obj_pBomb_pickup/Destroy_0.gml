/// @description Give the player 1 power bomb.
// You can write your code in this editor

if (hasCollided){
	// Play the ammo pickup sound
	audio_play_sound(snd_ammo_pickup, 1, false);
	global.pBombs++;
	if (global.pBombs > global.pBombsMax){
		global.pBombs = global.pBombsMax;	
	}
}