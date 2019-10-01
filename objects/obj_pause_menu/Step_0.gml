/// @description Menu Functionality
// You can write your code in this editor

#region Call the Parent Object's Event

event_inherited();
if (!fadingIn || xOffset > 0){
	xOffset = scr_update_value_delta(xOffset, (destX - xOffset) / 4);	
	if (!fadingIn){
		var selOption = selectedOption[X] * numColumns + selectedOption[Y];
		if (selOption != 4) {destX = -200;}
	}
}

#endregion

#region Unpausing the game with a second pause key press

var keyPause, keyReturn;
keyPause = keyboard_check_pressed(global.gKey[KEY.PAUSE_GAME]);
keyReturn = keyboard_check_pressed(global.gKey[KEY.RETURN]);
if (keyPause || keyReturn){
	exitingMenu = true;
	fadingIn = false;
	activeMenu = false;
	with(obj_menu_border){
		destroyOnZero = true;
		fadingIn = false;
	}
}

#endregion

#region Loading in the Game When the game screen is opaque

if (transitionObj != noone){
	var selOption = selectedOption[X] * numColumns + selectedOption[Y];
	with(transitionObj){
		if (alpha >= 1){
			if (selOption == 5){
				scr_unload_game();
				room_goto(rm_main_menu);
				opaqueTime = 1;
				alphaChangeVal = 0.1;
				break;
			}
			instance_destroy(other);
		}
	}
	destroyOnZero = false;
	return;
}

#endregion

#region Menu Option Functionality

if (activeMenu){
	var selOption = selectedOption[X] * numColumns + selectedOption[Y];
	if (selOption >  -1){
		fadingIn = false;
		activeMenu = false;
		switch(selOption){
			case 0: // Resuming the game
				with(obj_menu_border){
					destroyOnZero = true;
					fadingIn = false;
				}
				exitingMenu = true;
				break;
			case 1: // Opening Samus's Equipment Menu
				selectedOption[X] = -1;
				selectedOption[Y] = -1;
				// TODO -- create the equipment screen
				break;
			case 2: // Opening the Log Menu
				selectedOption[X] = -1;
				selectedOption[Y] = -1;
				// TODO -- create the log menu
				break;
			case 3: // Opening the Settings Menu
				isClosing = true;
				nextMenu = obj_settings_menu;
				break;
			case 4: // Exiting to the main menu
				transitionObj = instance_create_depth(0, 0, 5, obj_fade_transition);
				transitionObj.alphaChangeVal = 0.02;
				with(obj_controller) {playMusic = false;}
				break;
		}
	}
}

#endregion