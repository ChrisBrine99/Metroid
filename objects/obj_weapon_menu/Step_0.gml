/// @description Handles Moving Through/Closing the Menu
// You can write your code in this editor

#region Keyboard Inputs

var keyRight, keyLeft, keyCloseMenu;
keyRight = keyboard_check_pressed(vk_right);		// Shifts one item to the right in the weapon menu
keyLeft = keyboard_check_pressed(vk_left);			// Shifts one item to the left in the weapon menu
keyCloseMenu = keyboard_check_released(vk_shift);	// Closes the weapon menu 

#endregion

#region Menu Transition Effect

// Fading the Debug Menu in and out
if (fullMenu){
	if (!fadingOut){
		alpha += 0.1;
		if (alpha > 1){
			alpha = 1;	
		}
	} else{
		alpha -= 0.1;
		if (alpha < 0){
			alpha = 0;	
			instance_destroy(self);
			// Reset the Game State
			global.gameState = GAME_STATE.IN_GAME;
			// TODO -- Remove the Background Menu Blur
		}
		return;
	}
}

#endregion

#region Input Functionality (Sifting through Menu/Closing it)

if (fullMenu){
	if (keyRight){
		curIndex++;
		if (curIndex > menuSize - 1){
			curIndex = 0;	
		}
	} else if (keyLeft){
		curIndex--;
		if (curIndex < 0){
			curIndex = menuSize - 1;	
		}
	}
	
	if (keyCloseMenu){
		fadingOut = true;	
	}
} else{
	if (keyCloseMenu){
		instance_destroy(self);
		global.gameState = GAME_STATE.IN_GAME;
	}
}

#endregion