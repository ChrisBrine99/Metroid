/// @description Menu Functionality
// You can write your code in this editor

#region Call the Parent Object's Event

event_inherited();
if (!fadingIn || xOffset > 0){
	xOffset = scr_update_value_delta(xOffset, (destX - xOffset) / 4);	
	if (!fadingIn) {destX = -200;}
}

#endregion

#region Individual Setting Menu Functionality

if (subMenu != noone){
	with(subMenu){
		if (activeMenu){
			var cOption, keyRight, keyLeft, keySelect;
			cOption = curOption[X] * numColumns + curOption[Y];	
			keyRight = keyboard_check_pressed(global.mKey[KEY.MENU_RIGHT]);
			keyLeft = keyboard_check_pressed(global.mKey[KEY.MENU_LEFT]);
			keySelect = keyboard_check_pressed(global.mKey[KEY.SELECT]);
			if (cOption != -1){
				var leftRightResult = keyRight - keyLeft;
				if  (keySelect || leftRightResult != 0){
					// Play the menu select sound effect
					if (leftRightResult != 0) {scr_play_sound(snd_menu_select1, 0, false, true);}
					switch(otherIndex){
						case 0: // Video Setting Input
							switch(cOption){
								case 1: // Toggling Full Screen Mode
								case 2: // Toggling v-sync
								case 4: // Toggling Bloom
								case 5: // Toggling the Scanline overlay
									global.oVideo[cOption] = !global.oVideo[cOption];
									// Reset the display when necessary
									if (cOption == 2){ // For enabling/disabling v-sync
										display_reset(0, global.oVideo[2]);	
									} else if (cOption == 1){ // For enabling/disabling full screen mode
										window_set_fullscreen(global.oVideo[1]);
										with(global.cameraID) {alarm[1] = 1;}
									} else if (cOption == 4) { // Removing/Creating the bloom object
										if (global.bloomID != noone) {instance_destroy(global.bloomID);}
										else {instance_create_depth(0, 0, 45, obj_bloom);}
									}
									break;
								case 0: // Altering the resolution
									global.oVideo[cOption] += leftRightResult;
									if (global.camWidth * global.oVideo[cOption] > display_get_width() || global.camHeight * global.oVideo[cOption] > display_get_height()){
										global.oVideo[cOption] = 1;	
									} else if (global.oVideo[cOption] <= 0){
										global.oVideo[cOption] = floor(display_get_height() / global.camHeight);
									}
									with(global.cameraID) {alarm[1] = 1;}
									break;
								case 3: // Setting the FPS Limit
									if (leftRightResult == 1){
										switch(global.oVideo[cOption]){
											case 30:
												global.oVideo[cOption] = 60;
												break;
											case 60:
												global.oVideo[cOption] = 90;
												break;
											case 90:
												global.oVideo[cOption] = 120;
												break;
											case 120:
												global.oVideo[cOption] = 144;
												break;
											case 144:
												global.oVideo[cOption] = 200;
												break;
											case 200:
												global.oVideo[cOption] = 240;
												break;
											case 240:
												global.oVideo[cOption] = 99999;
												break;
											default:
												global.oVideo[cOption] = 30;
												break;
										}
									} else{
										switch(global.oVideo[cOption]){
											case 30:
												global.oVideo[cOption] = 99999;
												break;
											case 60:
												global.oVideo[cOption] = 30;
												break;
											case 90:
												global.oVideo[cOption] = 60;
												break;
											case 120:
												global.oVideo[cOption] = 90;
												break;
											case 144:
												global.oVideo[cOption] = 120;
												break;
											case 200:
												global.oVideo[cOption] = 144;
												break;
											case 240:
												global.oVideo[cOption] = 200;
												break;
											default:
												global.oVideo[cOption] = 240;
												break;
										}	
									}
									break;
							}
							break;
						case 1: // Audio Setting Input
							if (cOption != 6){ // Change volumes
								global.oAudio[cOption] += (leftRightResult * 5);
								if (global.oAudio[cOption] > 100) {global.oAudio[cOption] = 0;}
								else if (global.oAudio[cOption] < 0) {global.oAudio[cOption] = 100;}
							} else{ // Muting background Music
								global.oAudio[cOption] = !global.oAudio[cOption];
							}
							// Reset the volume of the BGM (Other sounds are set automatically)
							with(obj_controller){
								audio_sound_gain(curSong, scr_volume_type(curSong), 0);
								alarm[0] = 1;
							}
							break;
						case 2: // Control Setting Input
							
							break;
					}
				}
			}
		}
		// Set the position of the SubMenu
		xPos = 115;
		yPos = 28;
		// Set the position of the SubMenu's description section
		xPosD = -10;
		yPosD = 104;
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
					otherIndex = 0;
					// Sets the setting options and their descriptions
					menuOption[0, 0] = "Resolution";
					optionDesc[0, 0] = "The size of the game's window. The lowest\npossible resolution is 320 by 180, whereas\nthe maximum is the current display's resolution.";
					menuOption[0, 1] = "Full-Screen";
					optionDesc[0, 1] = "Set the game to be in either windowed mode\nor full-screen mode.";
					menuOption[0, 2] = "V-Sync";
					optionDesc[0, 2] = "Enables vertical synchronization to avoid\nany screen tearing.";
					menuOption[0, 3] = "Frame Rate Limit";
					optionDesc[0, 3] = "Sets how many in-game frames will be drawn\nin one second. By default this value is\nuncapped.";
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
					otherIndex = 1;
					// Sets the setting options and their descriptions
					menuOption[0, 0] = "Master";
					optionDesc[0, 0] = "Determines the volume of everything in the\ngame, relative to their actual volumes.";
					menuOption[0, 1] = "Music";
					optionDesc[0, 1] = "The overall volume of the background music.\n(Note -- Doesn't Alter Ambience Volume)";
					menuOption[0, 2] = "Player";
					optionDesc[0, 2] = "The overall volume of the sounds produced\nby the player when in-game.\n(Ex. Footsteps, Jumping, Crouching, etc.)";
					menuOption[0, 3] = "Weapons";
					optionDesc[0, 3] = "The overall volume of the sounds produced\nby any in-game weaponry.\n(Ex. Player/Enemy Projectiles)";
					menuOption[0, 4] = "Environment";
					optionDesc[0, 4] = "The overall volume of the sounds produced\nby the game's environment.\n(Ex. Lava Bubbling, Ambience, etc.)";
					menuOption[0, 5] = "GUI";
					optionDesc[0, 5] = "The overall volume of the sounds produced\nby the game's HUD and GUI elements.\n(Ex. Weapon Menu, Main Menu, etc.)";
					menuOption[0, 6] = "Mute BGM";
					optionDesc[0, 6] = "Toggle this to enable and disable the game's\nbackground music.\n(Note -- Doesn't Disable Ambience)";
				}
				break;
			case 2: // Opening the Control Setting's Menu
				//subMenu = instance_create_depth(0, 0, depth, obj_sub_menu);
				//with(subMenu){
					// Set the size of the menu
					//numRows = array_length_1d(global.gKey) + array_length_1d(global.mKey);
					//numColumns = 1;
				//}
				selectedOption[X] = -1;
				selectedOption[Y] = -1;
				break;
			case 3: // Returning all options to their default settings
				file_delete("options.ini");
				scr_load_options("options");
				// Reset the volume of the BGM (Other sounds are set automatically)
				with(obj_controller){
					audio_sound_gain(curSong, scr_volume_type(curSong), 0);
					alarm[0] = 1;
				}
				with(global.cameraID) {alarm[1] = 1;}
				selectedOption[X] = -1;
				selectedOption[Y] = -1;
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
				// Set the width and height of the background rectangle
				bgWidth = 220;
				bgHeight = 14;
			}
		}
	}
}

#endregion