/// @description Setting Image Speed
// You can write your code in this editor

if (global.gameState == GAME_STATE.PAUSED){
	return;	
}

if (open){
	imgSpd = -0.75;
	if (imgIndex < 1){
		imgSpd = 0;
		imgIndex = 0;
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
	imgSpd = 0.75;
	// Play the Door sound effect
	if (!soundHasPlayed){
		scr_play_sound(snd_door, 0, false, true);
		soundHasPlayed = true;
	}
}