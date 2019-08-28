/// @description Menu Input Control
// You can write your code in this editor

#region Keyboard Input

var keyRight, keyLeft, keyUp, keyDown, keySelect, keyReturn;
keyRight = keyboard_check(global.mKey[KEY.MENU_RIGHT]);
keyLeft = keyboard_check(global.mKey[KEY.MENU_LEFT]);
keyUp = keyboard_check(global.mKey[KEY.MENU_UP]);
keyDown = keyboard_check(global.mKey[KEY.MENU_DOWN]);
keySelect = keyboard_check_pressed(global.mKey[KEY.SELECT]);
keyReturn = keyboard_check_pressed(global.mKey[KEY.RETURN]);

#endregion

#region Updating the Menu's Current Alpha level

scr_alpha_control_update();

if (alpha >= 1){activeMenu = true;}
else {activeMenu = false;}

// Don't allow the menu to function until the alpha is at 1
if (!activeMenu){
	return;
}

#endregion

#region Movings Between Menu Elements

if (selectedOption[X] == -1 && selectedOption[Y] == -1){
	if (keyRight || keyLeft || keyUp || keyDown){
		holdTimer = scr_update_value_delta(holdTimer, -1);
		if (holdTimer <= 0){
			if (keyDown && !keyUp){ // Moving down through the menu
				curOption[Y]++; 
				if (curOption[Y] > numRows - 1){
					curOption[Y] = 0;
				}
			} else if (keyUp && !keyDown){ // Moving up through the menu
				curOption[Y]--;
				if (curOption[Y] < 0){
					curOption[Y] = numRows - 1;	
				}
			}
			if (keyRight && !keyLeft){ // Move to the right in the menu
				curOption[X]++;
				if (curOption[X] > numColumns - 1){
					curOption[X] = 0;	
				}
			} else if (keyLeft && !keyRight){ // Move to the left in the menu
				curOption[X]--;
				if (curOption[X] < 0){
					curOption[X] = numColumns - 1;	
				}
				
			}
			// Play the menu move sound effect
			if (switchSound != -1){
				var result;
				result = keyRight - keyLeft;
				if (result != 0){ // Play for moving left or right through a menu
					if (numColumns > 1) {scr_play_sound(switchSound, 0, false, true);}
				}
				result = keyDown - keyUp;
				if (result != 0){ // Play for moving up or down through a menu
					if (numRows > 1) {scr_play_sound(switchSound, 0, false, true);}	
				}
			}
			// Reset the timer
			if (autoScroll == 0){
				autoScroll = 1;
				holdTimer = timeToAuto;
			} else{
				autoScroll = 2;
				holdTimer = shiftTimer;
			}
		}
	} else{
		autoScroll = 0;
		holdTimer = 0;
		return;
	}
}

if (keySelect){ // Selecting a menu option (If it is enabled)
	if (canUseSelect){
		selectedOption = curOption;
		// Play the menu select sound effect
		if (selectSound != -1){
			scr_play_sound(selectSound, 0, false, true);
		}
	}
}

if (keyReturn){ // Return to a previous menu/closing the menu (If it is enabled)
	if (canUseReturn){
		fadingIn = false;
		isClosing = true;
		// Play the menu return sound effect
		if (closeSound != -1){
			scr_play_sound(closeSound, 0, false, true);
		}
	}
}

#endregion