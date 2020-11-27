/// @description These functions help the menu objects with certain repeatable aspects, including: adding option
/// data and option information, adding control information, removing information for both sections of info,
/// menu movement relative to the user's input, and calculating the positions for control information.

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

/// @description Calculates the positional offsets relative to the given anchor position. Allows for dynamically
/// updating control prompt information during runtime.
/// @param anchor
function controls_calculate_position(_anchor){
	var _anchorPos = [0, 0];
	// Get the desired anchor position based on the _anchor value
	if (_anchor == LEFT_ANCHOR){
		_anchorPos = leftAnchor;
	} else if (_anchor == RIGHT_ANCHOR){
		_anchorPos = rightAnchor;
	}

	// Set the control font to be used for accurate calculations
	draw_set_font(controlsFont);

	// Loop through all available control information and calculate the positions of them relative to the anchor
	// they are locked to.
	var _length, _offset;
	_length = ds_list_size(controlsAnchor);
	_offset = 0;
	for (var i = 0; i < _length; i++){
		if (controlsAnchor[| i] != _anchor){
			continue; // Skip calculating positions for the opposite anchor
		}
	
		// Calculate the positional offset relative to the anchor's position and if its the right or left anchor
		controlsPos[| i * 2] = _anchorPos[X] + (_offset * -_anchor);
		controlsPos[| (i * 2) + 1] = _anchorPos[Y];
	
		// Update the offset values with the new control information that has been added
		_offset += sprite_get_width(controlsInfo[| i * 3]) + 1;
		if (controlsInfo[| (i * 3) + 2] != ""){ // Don't add an empty text field's width to the offset
			_offset += string_width(controlsInfo[| (i * 3) + 2]) + 6;
		}
	}
}

/// @description Adds control prompt information for the current menu. This information includes the sprite
/// used for the chosen keybinding, and the anchor it uses, which can be either the right or left one.
/// @param keybinding
/// @param anchor
/// @param info
/// @param calculatePositions
function controls_add_info(_keybinding, _anchor, _info, _calculatePositions){
	ds_list_add(controlsPos, 0, 0); // Every 2 indexes is one "element"
	ds_list_add(controlsAnchor, _anchor);

	var _imageData = keybinding_get_sprite(_keybinding);
	ds_list_add(controlsInfo, _imageData[0], _imageData[1], _info);

	// Finally, if needed, calculate the positions for the anchor's controls
	if (_calculatePositions){ // When initializing control info, the final index for each anchor should have this flag enabled.
		controls_calculate_position(_anchor);
	}
}

/// @description Removes data at the desired index and recalculates the positions of the controls for that
/// anchor group.
/// @param index
function controls_remove_info(_index){
	_anchor = controlsAnchor[| _index];

	// Deleting the position data
	var _trueIndex = _index * 2;
	ds_list_delete(controlsPos, _trueIndex);
	ds_list_delete(controlsPos, _trueIndex);
	// Deleting the anchor data
	ds_list_delete(controlsAnchor, _index);
	// Deleting the information data
	_trueIndex = _index * 3;
	ds_list_delete(controlsInfo, _trueIndex);
	ds_list_delete(controlsInfo, _trueIndex);
	ds_list_delete(controlsInfo, _trueIndex);

	// Finally, recalculate the position for the controls using that anchor
	controls_calculate_position(_anchor);
}

/// @description Adds an option to the menu's current list of available options. It also takes in information
/// for the options respective information and adds that to its respective lists as well.
/// @param option
/// @param optionInfo
/// @param isActive
function options_add_info(_option, _optionInfo, _isActive){
	// Add information about the option to its respective lists
	ds_list_add(option, _option);
	ds_list_add(optionActive, _isActive);
	ds_list_add(optionPosOffset, 0, 0);

	// Update the total menu size and recalculate the total rows in the menu
	numOptions = ds_list_size(option);
	menuDimensions[Y] = ceil(numOptions / menuDimensions[X]);

	// Finally, add the option information to its list as well
	ds_list_add(info, _optionInfo);
}

/// @description Removes option data from its respective ds_lists as well as its information from that ds_list.
/// @param index
function options_remove_info(_index){
	var _index2D = (_index * 2);
	// Remove the option's string, position offset data, and its active state
	ds_list_delete(option, _index);
	ds_list_delete(optionActive, _index);
	ds_list_delete(optionPosOffset, _index2D);
	ds_list_delete(optionPosOffset, _index2D + 1);

	// Update the total menu size and recalculate the total rows in the menu
	numOptions = ds_list_size(option);
	menuDimensions[Y] = floor(numOptions / menuDimensions[X]);

	// Finally, remove option information data from its ds_list
	ds_list_delete(info, _index);
}