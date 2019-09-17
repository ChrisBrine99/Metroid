/// @description Menu Functionality
// You can write your code in this editor

#region Call the Parent Object's Event

event_inherited();

#endregion

#region Individual Setting Menu Functionality

if (subMenu != noone){
	with(subMenu){
		if (!keyReturn){
			var cOption, nextVal;
			cOption = curOption[X] * numColumns + curOption[Y];	
			nextVal = (keyRight - keyLeft);
			if (cOption != -1){
				if (otherIndex == 0){ // Video Setting Input
					if (nextVal != 0 || keySelect){
						global.oVideo[cOption] = !global.oVideo[cOption];
					}
				} else if (otherIndex == 1){ // Audio Setting Input
					if (keySelect) {nextVal = 5;} // Always increase when the select button is pressed
					else {nextVal *= 5;}
					if (nextVal != 0) {global.oAudio[cOption] += nextVal;}
				} else if (otherIndex == 2){ // Control Setting Input
					
				}
			}
		}
	}
}

#endregion

#region Menu Option Functionality

if (activeMenu){
	var selOption = selectedOption[X] * numColumns + selectedOption[Y];
	if (selOption != -1){
		switch(selOption){
			case 0: // Opening the Video Setting's Menu
				break;
			case 1: // Opening the Audio Setting's Menu
				break;
			case 2: // Opening the Control Setting's Menu
				break;
			case 3: // Returning all options to their default settings
				file_delete("options.ini");
				scr_load_options("options");
				scr_save_options("options");
				// TODO -- Add prompt to let the user confirm that they wish to default their options
				break;
			case 4: // Return to the Main Menu/Pause Menu
				isClosing = false;
				fadingIn = false;
				activeMenu = false;
				break;
		}
	}
}

#endregion