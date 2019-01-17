/// @description Moving through the menu, and handling what happens when an option is selected
// You can write your code in this editor

// Call the parent's step event
event_inherited();

if (instance_exists(obj_fade)){
	audio_stop_all();
	if (obj_fade.setAlpha == 1){
		instance_destroy(obj_samus);
		instance_destroy(obj_controller);
		room_goto(rm_main_menu)	
	}
	return;
}

if (!menuTransition){
	// Returning to the main game
	if (keyboard_check_pressed(vk_escape)){
		audio_play_sound(snd_pause, 1, false);
		menuTransition = true;
		nextMenu = -1;
	}
	// Button Functionality
	if (selectedOption == curOption){
		menuTransition = true;
		switch(selectedOption){
			case 0: // Returning to the game
				nextMenu = -1;
				break;
			case 1: // Going into the options
				nextMenu = -1;
				break;
			case 2: // Exiting the Game
				nextMenu = obj_main_menu;
				menuTransition = false;
				scr_create_fade(global.camX, global.camY, c_black, 0, false);
				break;
		}	
	}
}