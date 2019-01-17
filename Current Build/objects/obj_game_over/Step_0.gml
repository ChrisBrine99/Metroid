/// @description Button Functionality
// You can write your code in this editor

// Call the parent's step event
event_inherited();

// Selecting an option
if (selectedOption == curOption){
	switch(selectedOption){
		case 0: // Continue from the last save
			scr_create_fade(0, 0, c_black, 0, false);
			if (obj_fade.setAlpha == 1){
				scr_start_game(global.fileName);
			}
			break;
		case 1: // Return to the Main Menu
			scr_create_fade(0, 0, c_black, 0, false);
			if (obj_fade.setAlpha == 1)
				room_goto(rm_main_menu);
			break;
	}
}