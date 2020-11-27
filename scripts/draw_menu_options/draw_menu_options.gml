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