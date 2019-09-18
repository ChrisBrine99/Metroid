/// @description Drawing the basic sub menu
// You can write your code in this editor

if (alpha > 0){
	// Set the alpha channel to the object's current value
	draw_set_alpha(alpha);
	
	// Drawing the menu to the screen
	draw_set_font(font);
	var regCol, regOCol, selCol, selOCol;
	regCol = c_gray;
	regOCol = c_dkgray;
	selCol = c_lime;
	selOCol = c_green;
	for (var i = firstDrawn[X]; i < firstDrawn[X] + numToDraw[X]; i++){
		var xOffset = 150 * (i - firstDrawn[X]);
		for (var ii = firstDrawn[Y]; ii < firstDrawn[Y] + numToDraw[Y]; ii++){
			var yOffset = 15 * (i - firstDrawn[Y]);
			if (curOption[X] == i && curOption[Y] == ii){ // The normal stat of the menu option
				draw_text_outline(xPos + xOffset, yPos + yOffset, menuOption[i, ii], selCol, selOCol);
			} else{ // If the menu option is currently being highlighted by the user
				draw_text_outline(xPos + xOffset, yPos + yOffset, menuOption[i, ii], regCol, regOCol);	
			}
		}
	}
	
	// Drawing the weapon's description onto the screen
	if (displayTxt != optionDesc[curOption[X], curOption[Y]]){
		displayTxt = optionDesc[curOption[X], curOption[Y]];
		// Reset these variables whenever the description changes
		curDisplayedStr = "";
		curChar = 1;
		nextChar = 1;
	}
	// Checking if the text needs to be scrolled or not
	if (displayTxt != curDisplayedStr){
		var nChar = floor(nextChar);
		if (nChar > curChar){
			curDisplayedStr += string_copy(displayTxt, curChar, nChar - curChar);
			curChar = nChar;
		}
		nextChar = scr_update_value_delta(nextChar, txtSpeed);
	}
	draw_text_outline(xPos + xPosD, yPos + yPosD, curDisplayedStr, c_white, c_gray);
	
	// Return the alpha back to its default (Opaque)
	draw_set_alpha(1);
}