/// @description Menu Controls
// You can write your code in this editor

// Keyboard Variables
keyUp = keyboard_check_pressed(global.key[10]);		// Scrolling up through a menu
keyDown = keyboard_check_pressed(global.key[11]);	// Scrolling down through a menu
keyLeft = keyboard_check_pressed(global.key[13]);	// Shifting to the left in the menu
keyRight = keyboard_check_pressed(global.key[12]);	// Shifting to the right in the menu
keyUpHold = keyboard_check(global.key[10]);			// Holding the up key
keyDownHold = keyboard_check(global.key[11]);		// Holding the down key
keySelect = keyboard_check_pressed(global.key[14]);	// Selecting a menu's given option
keyReturn = keyboard_check_pressed(global.key[15]); // Returning to a previous menu (If one exists)

if (selectedOption == -1 && !menuTransition){
	// Moving up the menu
	if (keyUpHold){
		if (cooldownTimer <= -1){
			nextTimer--;
			if (nextTimer <= 0){
				nextTimer = nextTimerMax;
				audio_play_sound(snd_beam_select, 1, false);
				curOption--;
				if (curOption == -1){
					curOption = menuSize - 1;	
				}
			}
			if (cooldownTimer == -1)
				cooldownTimer = 30;
		}
	}
	// Moving down the menu
	if (keyDownHold){
		if (cooldownTimer <= -1){
			nextTimer--;
			if (nextTimer <= 0){
				nextTimer = nextTimerMax;
				audio_play_sound(snd_beam_select, 1, false);
				curOption++;
				if (curOption == menuSize){
					curOption = 0;	
				}
			}
			if (cooldownTimer == -1)
				cooldownTimer = 30;
		}
	}
	if (cooldownTimer > 0){
		cooldownTimer--;
		if (cooldownTimer == 2)
			cooldownTimer = -2;
	}
	if (!keyUpHold && !keyDownHold){
		cooldownTimer = -1;
		nextTimer = 0;	
	}
	// Selecting an option
	if (keySelect){
		if (audio_is_playing(snd_pause)) audio_stop_sound(snd_pause);
		audio_play_sound(snd_pause, 1, false);
		selectedOption = curOption;
	}
	// Going back to a previous menu
	if (keyReturn){
		if (audio_is_playing(snd_pause)) audio_stop_sound(snd_pause);
		audio_play_sound(snd_pause, 1, false);
		nextMenu = prevMenu;
		menuTransition = true;
	}
}

// Menu transitions
if (menuTransition){
	alpha -= 0.1;
	if (alpha == 0){
		if (nextMenu != -1){
			var obj;
			obj = instance_create_depth(x, y, depth, nextMenu);
			obj.alpha = 0;
		}
		instance_destroy(self);
	}
}
else{
	if (alpha < 1){
		alpha += 0.1;
	}
}

if (room = rm_main_menu){
	// Play the menu theme
	if (!audio_is_playing(music_main_menu)){
		global.curSong = audio_play_sound(music_main_menu, 0, false);	
	}
	audio_sound_gain(global.curSong, global.option[3] / 100, 0);
}