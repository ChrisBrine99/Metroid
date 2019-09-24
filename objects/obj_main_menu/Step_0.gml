/// @description Menu Functionality
// You can write your code in this editor

#region Call the Parent Object's Event

event_inherited();
if (!fadingIn || xOffset > 0){
	xOffset = scr_update_value_delta(xOffset, (destX - xOffset) / 4);	
	if (!fadingIn) {destX = -200;}
}

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
	var selOption = selectedOption[X] * numColumns + selectedOption[Y];
	if (selOption >  -1){
		fadingIn = false;
		activeMenu = false;
		switch(selOption){
			case 0: // Loading in the files/starting a new game
			case 1:
			case 2:
				transitionObj = instance_create_depth(0, 0, 5, obj_fade_transition);
				transitionObj.alphaChangeVal = 0.02;
				fileToLoad = "file0" + string(selectedOption[Y] + 1);
				with(obj_controller) {playMusic = false;}
				break;
			case 3: // Opening the Options Menu
				activeMenu = false;
				isClosing = true;
				nextMenu = obj_settings_menu;
				break;
			case 4: // Exiting to Desktop
				exitingGame = true;
				break;
		}
	}
}

#endregion