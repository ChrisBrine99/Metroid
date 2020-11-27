/// @description Functions that are called in order to draw each section of the menu. These sections include:
/// the title, options, option information, control information, and cursor. Note that these are just the 
/// default functions for drawing the menu sections, and any original functions can be used in place of
/// these functions for more specific approaches.

/// @description Draws the title for the current menu using the outline shader that should be set BEFORE
/// this function is called.
/// @param sOutlineColor
function draw_menu_title(_sOutlineColor){
	// Set the currently used alignment and font
	draw_set_halign(titleAlign[X]);
	draw_set_valign(titleAlign[Y]);
	outline_set_font(titleFont, global.fontTextures[? titleFont], sPixelWidth, sPixelHeight);

	// Next, set the colors used for the inside and outline
	draw_set_color(titleTextCol);
	shader_set_uniform_f_array(_sOutlineColor, titleOutlineCol);

	// Finally, display the title at its set position
	draw_text(titlePos[X], titlePos[Y], title);
}

/// @description Draws the options for the current menu using the outline shader that should be set BEFORE
/// this function is called.
/// @param sOutlineColor
function draw_menu_options(_sOutlineColor){
	// Set the currently used alignment and font
	draw_set_halign(optionAlign[X]);
	draw_set_valign(optionAlign[Y]);
	outline_set_font(optionFont, global.fontTextures[? optionFont], sPixelWidth, sPixelHeight);

	var _indexY, _indexX, _curOption, _index2D;
	_indexY = 0;
	_indexX = 0;
	for (var yy = firstDrawn[Y]; yy < firstDrawn[Y] + numDrawn[Y]; yy++){
		// Go through every element on that row and draw it
		for (var xx = firstDrawn[X]; xx < firstDrawn[X] + numDrawn[X]; xx++){
			_curOption = (menuDimensions[X] * yy) + xx; // Gets the option's true index within the menu based on its width
			_index2D = _curOption * 2;
		
			// Early exit if the _curOption variable is greater than the menu's size
			if (_curOption >= numOptions){
				break;
			}
		
			// If the menu option is inactive; just display it with the inactive text color
			if (!optionActive[| _curOption]){
				draw_set_color(optionInactiveCol);
				shader_set_uniform_f_array(_sOutlineColor, optionInactiveOutlineCol);
				draw_text(optionPos[X] + optionPosOffset[| _index2D] + (optionSpacing[X] * _indexX), optionPos[Y] + optionPosOffset[| _index2D + 1] + (optionSpacing[Y] * _indexY), option[| _curOption]);
				continue;
			}

			if (_curOption == selOption){ // The option is using the default selection colors
				draw_set_color(optionSelectCol);
				shader_set_uniform_f_array(_sOutlineColor, optionSelectOutlineCol);
			} else if (_curOption == auxSelOption){ // The option is using the auxillary selection colors
				draw_set_color(optionAuxSelectCol);
				shader_set_uniform_f_array(_sOutlineColor, optionAuxSelectOutlineCol);
			} else if (_curOption == curOption){ // The option is using the highlighted colors
				draw_set_color(optionHighlightCol);
				shader_set_uniform_f_array(_sOutlineColor, optionHighlightOutlineCol);
			} else{ // The option is using the standard colors
				draw_set_color(optionCol);
				shader_set_uniform_f_array(_sOutlineColor, optionOutlineCol);
			}
			// Draw the text using its relative position variables
			draw_text(optionPos[X] + optionPosOffset[| _index2D] + (optionSpacing[X] * _indexX), optionPos[Y] + optionPosOffset[| _index2D + 1] + (optionSpacing[Y] * _indexY), option[| _curOption]);
	
			// Finally, increment the X index variable
			_indexX++;
		}
		// Early exit if the _curOption variable is greater than the menu's size
		if (_curOption >= numOptions){
			break;
		}
		// Finally, increment the Y index and reset the X index
		_indexY++;
		_indexX = 0;
	}
}

/// @description Draws the information for currently highlighted option at the position specified within the menu.
/// If the scrolling text flag is enabled, the numCharacters variable will be updated relative to the text speed
/// set within the accessibility settings.
/// @param sOutlineColor
function draw_menu_options_info(_sOutlineColor){
	// If the currently highlighted option isn't active, don't draw its information
	if (!optionActive[| curOption]){
		return;
	}

	// Set the currently used alignment and font
	draw_set_halign(infoAlign[X]);
	draw_set_valign(infoAlign[Y]);
	outline_set_font(infoFont, global.fontTextures[? infoFont], sPixelWidth, sPixelHeight);

	// Set the color of the font's text and its outline
	draw_set_color(infoTextCol);
	shader_set_uniform_f_array(_sOutlineColor, infoOutlineCol);

	if (scrollingInfoText){ // Draw the currently visible portion of the text; adding to it every frame
		var _curInfoText = string_copy(info[| curOption], 0, numCharacters);
		draw_text(infoPos[X], infoPos[Y], _curInfoText);
		numCharacters += 0.75 * global.deltaTime;
	} else{ // Draw the full string instantly if no scrolling is being used
		draw_text(infoPos[X], infoPos[Y], info[| curOption]);
	}
}

/// @description Draw the menu's control prompts relative to their calculated positions. The sprites for the
/// keybindings are calculated with different methods depending on the anchor they used for positioning.
/// @param sOutlineColor
function draw_menu_controls(_sOutlineColor){
	// Set the currently used font; also set the vertical alignment back to its default
	draw_set_valign(fa_top);
	outline_set_font(controlsFont, global.fontTextures[? controlsFont], sPixelWidth, sPixelHeight);

	// Set the color of the font's text and its outline
	draw_set_color(controlsTextCol);
	shader_set_uniform_f_array(_sOutlineColor, controlsOutlineCol);

	var _length, _index2D, _index3D, _spriteWidth;
	_length = ds_list_size(controlsAnchor);
	for (var i = 0; i < _length; i++){
		_index2D = i * 2;
		_index3D = i * 3;
		if (controlsAnchor[| i] == LEFT_ANCHOR){
			draw_set_halign(fa_left);
			// Draw the control information without any adjustment to the position
			draw_sprite(controlsInfo[| _index3D], controlsInfo[| _index3D + 1], controlsPos[| _index2D], controlsPos[| _index2D + 1]);
			draw_text(controlsPos[| _index2D] + (sprite_get_width(controlsInfo[| _index3D]) + 2), controlsPos[| _index2D + 1] + 2, controlsInfo[| _index3D + 2]);
		} else if (controlsAnchor[| i] == RIGHT_ANCHOR){
			draw_set_halign(fa_right);
			// Factor in the sprite's width relative to the position of the control information
			_spriteWidth = sprite_get_width(controlsInfo[| _index3D]);
			draw_sprite(controlsInfo[| _index3D], controlsInfo[| _index3D + 1], controlsPos[| _index2D] - _spriteWidth, controlsPos[| _index2D + 1]);
			draw_text(controlsPos[| _index2D] - (_spriteWidth + 1), controlsPos[| _index2D + 1] + 2, controlsInfo[| _index3D + 2]);
		}
	}
}

/// @description Draws the cursors position relative to the option's position. It's important to draw the cursor
/// before activating the menu's shader otherwise adverse effects may occur. No arguments needed.
function draw_menu_cursor(){
	var _xPosition, _yPosition;
	_xPosition = (cursorPos[X] + optionPos[X]) + ((curOption % menuDimensions[X]) * optionSpacing[X]);
	_yPosition = (cursorPos[Y] + optionPos[Y]) + (floor(curOption / (menuDimensions[X] * menuDimensions[Y])) * optionSpacing[Y]);

	draw_sprite(cursorSprite, 0, _xPosition, _yPosition);
}