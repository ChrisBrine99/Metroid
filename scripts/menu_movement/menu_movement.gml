/// @description Provides input functionality for the menu's cursor. Enables selecting of menu options,
/// moving between them, and backing out of selecting an item, or exiting the menu.

function menu_movement(){
	// Update current input states for the keyboard variables
	keyRight = keyboard_check(rightIndex);
	keyLeft = keyboard_check(leftIndex);
	keyUp = keyboard_check(upIndex);
	keyDown = keyboard_check(downIndex);
	keySelect = keyboard_check_pressed(ord("Z"));
	keyReturn = keyboard_check_pressed(ord("X"));
	keyAuxReturn = keyboard_check_pressed(auxReturnIndex);

	// Set the previous option to whatever the curOption value is before any input is considered
	prevOption = curOption;

	// Pressing the return key will ignore any directional menu input and instantly exit
	if (keyReturn || keyAuxReturn){
		// TODO -- Play Return Sound Here if Enabled
		return;
	}

	if (keySelect){
		// TODO -- Play Select Sound Here if Enabled
		return;
	}

	// Menu has one or less than one element OR holdTimer is set to -1; don't bother updating menu cursor
	if (numOptions <= 1){
		if (!keyRight && !keyLeft && !keyUp && !keyDown){ // Reset auto move key if all directions are released
			holdTimer = 0;
		}
		return;
	}

	// If any directional keys have been pressed, attempt to update the cursor
	if (keyRight || keyLeft || keyUp || keyDown){
		holdTimer -= global.deltaTime;
		// Update the currently highlighted option (curOption)
		if (holdTimer <= 0){
			if (!isAutoScrolling){ // Enable the menu's auto-scrolling
				holdTimer = timeToHold;
				isAutoScrolling = true;
			} else{ // Reduce time needed to move cursor for auto-scrolling
				holdTimer = timeToHold * autoScrollSpeed;
			}
		
		
			// Moving up/down to different rows in the menu
			if ((keyUp && !keyDown) || (keyDown && !keyUp)){
				curOption += (keyDown - keyUp) * menuDimensions[X];
			
				var _curRow = floor(curOption / menuDimensions[X]);
				if (keyUp && firstDrawn[Y] > 0 && _curRow < firstDrawn[Y] + scrollOffset[Y]){
					firstDrawn[Y]--; // Shift the visible region upward
				} else if (keyDown && firstDrawn[Y] < menuDimensions[Y] - numDrawn[Y] && _curRow >= firstDrawn[Y] + (numDrawn[Y] - scrollOffset[Y])){
					firstDrawn[Y]++; // Shift the visible region downward
				}
			
				if (curOption >= numOptions){ // Wrap the currently highlighted option to the lowest value for that column
					curOption = curOption % menuDimensions[X];
					// Reset the menu's visible vertical region back to a range of 0 to number of rows to draw
					firstDrawn[Y] = 0;
				} else if (curOption < 0){ // Wrap the currently highlighted option to the highest value of that column
					curOption = ((menuDimensions[Y] - 1) * menuDimensions[X]) + prevOption;
					if (curOption >= numOptions){
						curOption -= menuDimensions[X];
					}
					// Offset the visible vertical region to its highest possible value, but no value below 0
					firstDrawn[Y] = max(0, menuDimensions[Y] - numDrawn[Y]);
				}
			}
		
			// Moving left/right through the menu if there is more than one option per row
			if (menuDimensions[X] > 1){
				if ((keyLeft && !keyRight) || (!keyLeft && keyRight)){
					curOption += keyRight - keyLeft;
				
					var _curColumn = curOption % menuDimensions[X];
					if (keyLeft && firstDrawn[X] > 0 && _curColumn < firstDrawn[X] + scrollOffset[X]){
						firstDrawn[X]--; // Shift the visible region to the left
					} else if (keyRight && firstDrawn[X] < menuDimensions[X] - numDrawn[X] && _curColumn >= firstDrawn[X] + (numDrawn[X] - scrollOffset[X])){
						firstDrawn[X]++; // Shift the visible region to the right
					}
				
					// Check if the cursor needs to wrap around to the other side
					if (keyRight && (curOption % menuDimensions[X] == 0 || curOption == numOptions)){
						if (curOption >= numOptions - 1 && curOption % menuDimensions[X] != 0){ // Wrap around to the left-size relative to the amount of options on that row
							curOption = (numOptions - 1) - ((numOptions - 1) % menuDimensions[X]);
						} else{ // Wrap around to the left-side as normal
							curOption -= menuDimensions[X];
						}
						firstDrawn[X] = 0;
					} else if (keyLeft && (curOption % menuDimensions[X] == menuDimensions[X] - 1 || curOption == -1)){ // Wrap around to the right
						curOption += menuDimensions[X];
						firstDrawn[X] = menuDimensions[X] - numDrawn[X];
						if (curOption >= numOptions - 1){ // Lock onto the option farthest to the right in the last row
							curOption = numOptions - 1;
							// Fix the offset for the first drawn column of options
							firstDrawn[X] = clamp((curOption % menuDimensions[X]) - scrollOffset[X], 0, menuDimensions[X] - numDrawn[X]);
						}
					}
				}
			}
			// Finally, reset the info text's character scrolling position
			numCharacters = 0;
		}
	} else{ // No directional keys are being held; reset auto-scroll stat and its associated timer
		isAutoScrolling = false;
		holdTimer = 0;
	}
}