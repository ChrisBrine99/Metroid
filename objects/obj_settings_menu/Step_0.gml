/// @description Menu Functionality
// You can write your code in this editor

#region Call the Parent Object's Event

event_inherited();

#endregion

#region Individual Setting Menu Functionality

if (subMenu != noone){
	with(subMenu){
		if (activeMenu){
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
		// Set the position of the SubMenu
		xPos = 130;
		yPos = 28;
	}
	return;
}

#endregion

#region Menu Option Functionality

if (activeMenu){
	var selOption = selectedOption[X] * numColumns + selectedOption[Y];
	if (selOption != -1){
		switch(selOption){
			case 0: // Opening the Video Setting's Menu
				subMenu = instance_create_depth(0, 0, depth, obj_sub_menu);
				with(subMenu){
					// Set the size of the menu
					numRows = array_length_1d(global.oVideo);
					numColumns = 1;
					// Sets the setting options and their descriptions
					menuOption[0, 0] = "Resolution";
					optionDesc[0, 0] = "The size of the game's window. The lowest\npossible resolution is 320 by 180, whereas the\nmaximum is the current display's resolution.";
					menuOption[0, 1] = "Full-Screen";
					optionDesc[0, 1] = "Set the game to be in either windowed mode\nor full-screen mode.";
					menuOption[0, 2] = "V-Sync";
					optionDesc[0, 2] = "Enables vertical synchronization to avoid\nany screen tearing.";
					menuOption[0, 3] = "Frame Rate Limit";
					optionDesc[0, 3] = "Sets how many frames per second will be\ndrawn in one second. By default this value is\nuncapped.";
					menuOption[0, 4] = "Bloom";
					optionDesc[0, 4] = "Toggles the bloom effect to be enabled or\ndisabled. Can help improve performance on\nweaker machines.";
					menuOption[0, 5] = "Scanlines";
					optionDesc[0, 5] = "Enables the scanline overlay in the game.\nDisabling can help improve performance, but\nonly very little.";
				}
				break;
			case 1: // Opening the Audio Setting's Menu
				subMenu = instance_create_depth(0, 0, depth, obj_sub_menu);
				with(subMenu){
					// Set the size of the menu
					numRows = array_length_1d(global.oAudio);
					numColumns = 1;
					// Sets the setting options and their descriptions
					menuOption[0, 0] = "Master";
					optionDesc[0, 0] = "Determines the volume of everything in the game, relative to their actual volumes.";
					menuOption[0, 1] = "Music";
					optionDesc[0, 1] = "The overall volume of the background music. (Note -- Doesn't Alter Ambience Volume)";
					menuOption[0, 2] = "Player";
					optionDesc[0, 2] = "The overall volume of the sounds produced by the player when in-game. (Ex. Footsteps, Jumping, Crouching, etc.)";
					menuOption[0, 3] = "Weapons";
					optionDesc[0, 3] = "The overall volume of the sounds produced by any in-game weaponry. (Ex. Player/Enemy Projectiles)";
					menuOption[0, 4] = "Environment";
					optionDesc[0, 4] = "The overall volume of the sounds produced by the game's environment. (Ex. Lava Bubbling, Ambience, etc.)";
					menuOption[0, 5] = "GUI";
					optionDesc[0, 5] = "The overall volume of the sounds made by the game's HUD and GUI elements. (Ex. Weapon Menu, Main Menu, etc.)";
					menuOption[0, 6] = "Mute BGM";
					optionDesc[0, 6] = "Toggle this to enable and disable the game's background music. (Note -- Doesn't Disable Ambience)";
				}
				break;
			case 2: // Opening the Control Setting's Menu
				subMenu = instance_create_depth(0, 0, depth, obj_sub_menu);
				with(subMenu){
					// Set the size of the menu
					numRows = array_length_1d(global.gKey) + array_length_1d(global.mKey);
					numColumns = 1;
				}
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
		// Code that is shared between sub menu creation on all three occurances
		if (subMenu != noone){
			with(subMenu){
				prevMenu = other.object_index;
				numToDraw[X] = 1;
				numToDraw[Y] = 6;	
			}
		}
	}
}

#endregion