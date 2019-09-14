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
	for (var i = 0; i < numColumns; i++){
		for (var ii = 0; ii < numRows; ii++){
			if (curOption[X] == i && curOption[Y] == ii){ // The normal stat of the menu option
				draw_text_outline(xPos, yPos + (15 * ii), menuOption[i, ii], selCol, selOCol);
			} else{ // If the menu option is currently being highlighted by the user
				draw_text_outline(xPos, yPos + (15 * ii), menuOption[i, ii], regCol, regOCol);	
			}
		}
	}
	
	// Return the alpha back to its default (Opaque)
	draw_set_alpha(1);
}