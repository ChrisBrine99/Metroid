/// @description Setting Image Speed
// You can write your code in this editor

if (global.gameState == GAME_STATE.PAUSED){
	image_speed = 0;
	return;	
}

if (open){
	image_speed = -1;
	if (image_index < 1){
		image_speed = 0;
		image_index = 0;
		open = false;
		soundHasPlayed = false;
		return;
	}
	// Play the Door sound effect
	if (!soundHasPlayed){
		scr_play_sound(snd_door, 0, false, true);
		soundHasPlayed = true;
	}
} else if (unlocked){
	image_speed = 1;
	// Play the Door sound effect
	if (!soundHasPlayed){
		scr_play_sound(snd_door, 0, false, true);
		soundHasPlayed = true;
	}
}