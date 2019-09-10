/// @description Menu Functionality
// You can write your code in this editor

#region Call the Parent Object's Event

event_inherited();

#endregion

#region Loading in the Game When the game screen is opaque

if (transitionObj != noone){
	with(transitionObj){
		alphaChangeVal = 0.1;
		if (alpha == 1){
			show_debug_message("TEST");
			scr_load_progress(other.fileToLoad);
			obj_player.alarm[1] = (1 / alphaChangeVal) + (self.opaqueTime / global.deltaTime);
		}
	}
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
				fileToLoad = "file0" + string(selectedOption[Y] + 1);
				with(obj_controller) {playMusic = false;}
				break;
			case 3: // Opening the Options Menu
				isClosing = true;
				//nextMenu = obj_options_menu;
				break;
			case 4: // Exiting to Desktop
				exitingGame = true;
				break;
		}
	}
}

#endregion