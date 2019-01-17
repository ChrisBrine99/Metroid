/// @description Moving through the menu, and handling what happens when an option is selected
// You can write your code in this editor

// Call the parent's step event
event_inherited();

// Button Functionality
if (selectedOption == curOption){
	switch(selectedOption){
		case 0: // Opening the sub menu for File 01
			scr_start_game("File01");
			break;
		case 1: // Opening the sub menu for File 02
			scr_start_game("File02");
			break;
		case 2: // Opening the sub menu for File 03
			scr_start_game("File03");
			break;
		case 3: // Going into the options
			menuTransition = true;
			nextMenu = obj_title_menu;
			break;
		case 4: // Exiting the Game
			scr_create_fade(0, 0, c_black, 0, false);
			if (obj_fade.setAlpha == 1)
				game_end();
			break;
	}	
}

// Deleting a file
if (curOption >= 0 && curOption <= 2){
	if (keyboard_check_pressed(ord("D"))){
		var filename = "File0" + string(curOption + 1) + ".dat";
		// Check if the file exists
		if (file_exists(filename)){
			file_delete(filename);
			// Return all the menu display variables to zero
			enData[curOption] = 0;
			eTankData[curOption] = 0;
			eTankMaxData[curOption] = 0;
			hourData[curOption] = 0;
			minuteData[curOption] = 0;
		}
	}
}

// Play the menu theme
if (!audio_is_playing(music_main_menu)){
	audio_play_sound(music_main_menu, 0, false);
}