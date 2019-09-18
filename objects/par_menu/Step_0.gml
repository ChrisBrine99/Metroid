/// @description Menu Input Control
// You can write your code in this editor

#region Keyboard Input

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
				// Shifting the visible portion of the menu downward
				if (firstDrawn[Y] < numRows - numToDraw[Y]){
					firstDrawn[Y]++;	
				}
			} else if (keyUp && !keyDown){ // Moving up through the menu
				curOption[Y]--;
				if (curOption[Y] < 0){
					curOption[Y] = numRows - 1;	
				}
				// Shifting the visible portion of the menu upward
				if (firstDrawn[Y] > 0){
					firstDrawn[Y]--;	
				}
			}
			if (keyRight && !keyLeft){ // Move to the right in the menu
				curOption[X]++;
				if (curOption[X] > numColumns - 1){
					curOption[X] = 0;	
				}
				// Shifting the visible portion of the menu to the right
				if (firstDrawn[X] < numColumns - numToDraw[X]){
					firstDrawn[X]++;	
				}
			} else if (keyLeft && !keyRight){ // Move to the left in the menu
				curOption[X]--;
				if (curOption[X] < 0){
					curOption[X] = numColumns - 1;	
				}
				// Shifting the visible portion of the menu upward
				if (firstDrawn[X] > 0){
					firstDrawn[X]--;	
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
	}
	
	// Selecting a menu option (If it is enabled)
	if (keySelect){
		if (canUseSelect){
			if (selectSound != -1){
				scr_play_sound(selectSound, 0, false, true);	
			}
			selectedOption[X] = curOption[X];
			selectedOption[Y] = curOption[Y];
			// Play the menu select sound effect
			if (selectSound != -1){
				scr_play_sound(selectSound, 0, false, true);
			}
		}
	}

	// Return to a previous menu/closing the menu (If it is enabled)
	if (keyReturn){ 
		if (canUseReturn){
			fadingIn = false;
			isClosing = false;
			// Play the menu return sound effect
			if (closeSound != -1){
				scr_play_sound(closeSound, 0, false, true);
			}
		}
	}
}

#endregion