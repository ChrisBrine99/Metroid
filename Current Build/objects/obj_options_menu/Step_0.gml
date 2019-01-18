/// @description Moving through the menu, and handling what happens when an option is selected
// You can write your code in this editor

// Call the parent's step event
event_inherited();

// Button Functionality
if (selectedOption == curOption){
	switch(selectedOption){
		case 0: // Enabling/Disabling Scanlines
			break;
		case 1: // Option2
			break;
		case 2: // Option3
			break;
		case 3: // Option4
			break;
		case 4: // Option5
			break;
		case 5: // Option6
			break;
		case 6: // Return to the previous menu
			menuTransition = true;
			nextMenu = obj_main_menu;
			break;
	}
	if (selectedOption != 6)
		selectedOption = -1;
}