/// @description Menu Controls
// You can write your code in this editor

if (selectedOption == -1){
	// Moving up the menu
	if (keyboard_check_pressed(vk_up)){
		audio_play_sound(snd_beam_select, 1, false);
		curOption--;
		if (curOption == -1){
			curOption = menuSize - 1;	
		}
	}
	// Moving down the menu
	if (keyboard_check_pressed(vk_down)){
		audio_play_sound(snd_beam_select, 1, false);
		curOption++;
		if (curOption == menuSize){
			curOption = 0;	
		}
	}
	// Selecting an option
	if (keyboard_check_pressed(ord("Z"))){
		audio_play_sound(snd_pause, 1, false);
		selectedOption = curOption;
	}
}

// Menu transitions
if (menuTransition){
	prevMenu = object_index;
	alpha -= 0.1;
	if (alpha == 0){
		if (nextMenu != -1){
			var obj;
			obj = instance_create_depth(x, y, depth, nextMenu);
			obj.alpha = 0;
			obj.prevMenu = prevMenu;
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
		audio_play_sound(music_main_menu, 0, false);	
	}
}