/// @description Menu Functionality
// You can write your code in this editor

#region Call the Parent Object's Event

event_inherited();

#endregion

#region Loading in the Game When the game screen is opaque

if (transitionObj != noone){
	with(transitionObj){
		if (alpha >= 1){
			scr_load_progress(other.fileToLoad);
			obj_player.alarm[1] = ((1 / alphaChangeVal) + (self.opaqueTime / 4)) / global.deltaTime;
			instance_destroy(other);
		}
	}
	destroyOnZero = false;
	return;
}

#endregion

#region Menu Option Functionality

if (activeMenu){
	if (selectedOption[Y] != -1){
		fadingIn = false;
		activeMenu = false;
		switch(selectedOption[Y]){
			case 0: // Loading in the files/starting a new game
			case 1:
			case 2:
				transitionObj = instance_create_depth(0, 0, 45, obj_fade_transition);
				transitionObj.alphaChangeVal = 0.02;
				fileToLoad = "file0" + string(selectedOption[Y] + 1);
				with(obj_controller) {playMusic = false;}
				break;
			case 3: // Opening the Options Menu
				fadingIn = true;
				activeMenu = false;
				//isClosing = true;
				//nextMenu = obj_options_menu;
				// Creating a temporary sub menu
				/*subMenu = instance_create_depth(0, 0, 10, obj_sub_menu);
				with(subMenu){
					prevMenu = other.object_index;
					xPos = 30;
					yPos = 30;
					// The menu's size (X by Y)
					numColumns = 1;
					numRows = 5;
					// The menu elements
					menuOption[0, 0] = "Option 1";
					menuOption[0, 1] = "Option 2";
					menuOption[0, 2] = "Option 3";
					menuOption[0, 3] = "Option 4";
					menuOption[0, 4] = "Option 5";
				}*/
				break;
			case 4: // Exiting to Desktop
				exitingGame = true;
				break;
		}
	}
}

#endregion