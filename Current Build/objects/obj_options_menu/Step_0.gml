/// @description Moving through the menu, and handling what happens when an option is selected
// You can write your code in this editor

// Call the parent's step event
event_inherited();

// Button Functionality
if (selectedOption == curOption){
	switch(selectedOption){
		case 0: // Toggling the scanlines
			if (!global.option[0]) global.option[0] = true;
			else global.option[0] = false;
			selectedOption = -1;
			break;
		case 1: // Toggling V-Sync
			if (!global.option[1]) global.option[1] = true;
			else global.option[1] = false;
			display_reset(0, global.option[1]);
			selectedOption = -1;
			break;
		case 2: // Changing the resolution scale
			if (global.camWidth * global.option[2] < display_get_width()) global.option[2]++;
			else global.option[2] = 1;
			obj_camera.scale = global.option[2];
			selectedOption = -1;
			break;
		case 3: // Changing the music volume
			global.option[curOption] += 5;
			if (global.option[curOption] > 100){
				global.option[curOption] = 0;	
			}
			audio_sound_gain(global.curSong, global.option[3], 0);
			optionStr[3] = string(global.option[3]);
			selectedOption = -1;
			break;
		case 4: // Changing the sound fx volume
			global.option[curOption] += 5;
			if (global.option[curOption] > 100){
				global.option[curOption] = 0;	
			}
			scr_set_volume();
			optionStr[4] = string(global.option[4]);
			selectedOption = -1;
			break;
		case 5: // Opening the keybinds menu 
			menuTransition = true;
			nextMenu = obj_controls_menu;
			break;
		case 6: // Resetting options to their defaults
			scr_default_options();
			selectedOption = -1;
			break;
		case 7: // Exiting the options menu
			if (!menuTransition)
				scr_save_options("options");
			menuTransition = true;
			if (room == rm_main_menu) nextMenu = obj_main_menu;
			else nextMenu = obj_pause_menu;
			break;
	}
	if (selectedOption < 5) {
		for (var i = 0; i < 2; i++) {
			if (global.option[i] == true) optionStr[i] = "On";
			else optionStr[i] = "Off";
		}
		optionStr[2] = string(global.option[2]) + "x [" + string(global.camWidth * global.option[2]) + " x " + string(global.camHeight * global.option[2]) + "]";
	}
}

// Changing the volume
if (curOption == 3 || curOption == 4){
	var sFXvol, mFXvol;
	mFXvol = global.option[3];
	sFXvol = global.option[4];
	if (keyLeft){
		global.option[curOption] -= 5;
		if (global.option[curOption] < 0){
			global.option[curOption] = 100;
		}
		if (audio_is_playing(snd_pause)) audio_stop_sound(snd_pause);
		audio_play_sound(snd_pause, 1, false);
	}
	if (keyRight){
		global.option[curOption] += 5;
		if (global.option[curOption] > 100){
			global.option[curOption] = 0;	
		}
		if (audio_is_playing(snd_pause)) audio_stop_sound(snd_pause);
		audio_play_sound(snd_pause, 1, false);
	}
	// Altering the music volume
	if (global.option[3] != mFXvol){
		audio_sound_gain(global.curSong, global.option[3], 0);
		optionStr[3] = string(global.option[3]);
	}
	// Altering the sound effect volume
	if (global.option[4] != sFXvol){
		scr_set_volume();
		optionStr[4] = string(global.option[4]);
	}
}