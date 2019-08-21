/// @description Handles Moving Through/Closing the Menu
// You can write your code in this editor

#region Keyboard Inputs

var keyRight, keyLeft, keyCloseMenu;
keyRight = keyboard_check_pressed(global.gKey[KEY.GAME_RIGHT]);
keyLeft = keyboard_check_pressed(global.gKey[KEY.GAME_LEFT]);
keyCloseMenu = keyboard_check(global.gKey[KEY.SWAP_WEAPON]);		

#endregion

#region Menu Transition Effect

// Fading the Debug Menu in and out
if (fullMenu){
	if (isVisible){
		alpha = scr_update_value_delta(alpha, 0.1);
		if (alpha > 1){
			alpha = 1;	
		}
	} else{
		alpha = scr_update_value_delta(alpha, -0.1);
		if (alpha < 0){
			alpha = 0;	
			instance_destroy(self);
			// Reset the Game State
			global.gameState = GAME_STATE.IN_GAME;
		}
		return;
	}
} else{
	// Transition to the full menu
	if (obj_hud.alpha < 0.1){
		fullMenu = true;
	}
}

#endregion

#region Input Functionality (Sifting through Menu/Closing it)

if (fullMenu){
	if (menuSize > 1){
		if (keyRight){
			curIndex++;
			if (curIndex > menuSize - 1){
				curIndex = 0;	
			}
			scr_play_sound(snd_beam_select, 0, false, true);
		} else if (keyLeft){
			curIndex--;
			if (curIndex < 0){
				curIndex = menuSize - 1;	
			}
			scr_play_sound(snd_beam_select, 0, false, true);
		}
	}
	
	if (!keyCloseMenu){
		isVisible = false;
	}
} else{
	if (!keyCloseMenu && obj_hud.alpha == 1){
		instance_destroy(self);
		global.gameState = GAME_STATE.IN_GAME;
	}
}

#endregion