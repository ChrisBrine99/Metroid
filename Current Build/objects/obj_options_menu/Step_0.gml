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
		case 2: 
			selectedOption = -1;
			break;
		case 3: // Changing the windowed mode scaling
			if (global.camWidth * global.option[3] < display_get_width()) global.option[3]++;
			else global.option[3] = 1;
			obj_camera.scale = global.option[3];
			selectedOption = -1;
			break;
		case 4: // Opening the keybinds menu 
			menuTransition = true;
			nextMenu = obj_controls_menu;
			break;
		case 5: // Resetting options to their defaults
			scr_default_options();
			selectedOption = -1;
			break;
		case 6: // Exiting the options menu
			if (!menuTransition)
				scr_save_options("options");
			menuTransition = true;
			if (room == rm_main_menu) nextMenu = obj_main_menu;
			else nextMenu = obj_pause_menu;
			break;
	}
	if (selectedOption < 4) {
		for (var i = 0; i < 3; i++) {
			if (global.option[i] == true) optionStr[i] = "On";
			else optionStr[i] = "Off";
		}
		optionStr[3] = string(global.option[i]) + "x [" + string(global.camWidth * global.option[i]) + " x " + string(global.camHeight * global.option[i]) + "]";
	}
}