/// @description Moving through the menu, and handling what happens when an option is selected
// You can write your code in this editor

// Don't let the menu function whils the sub menu is open
if (instance_exists(obj_message_box)){
	if (obj_message_box.answer == true){
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
			beamData[curOption] = 0;
			equipData[curOption] = 0;
			missData[curOption] = 0;
			sMissData[curOption] = 0;
			pBombData[curOption] = 0;
		}
	}
	return;
}

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
			nextMenu = obj_options_menu;
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
			audio_play_sound(snd_pause, 1, false);
			var obj;
			obj = instance_create_depth(0, 0, depth - 1, obj_message_box);
			obj.alpha = 0;
			obj.strPrompt = "Delete this file?";
		}
	}
}