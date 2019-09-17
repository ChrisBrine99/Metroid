/// @description Drawing the Settings Menu
// You can write your code in this editor

// Some helpful variables to keep the rest of the code a little cleaner looking
var regCol, regOCol, selCol, selOCol;
regCol = c_gray;
regOCol = c_dkgray;
selCol = c_lime;
selOCol = c_green;

#region Drawing the Requied Sub-Menu

if (subMenu != noone){
	var selOption = selectedOption[X] * numColumns + selectedOption[Y];
	with(subMenu){
		if (alpha > 0){
			draw_set_font(font_gui_xSmall);
			switch(selOption){
				case 0: // Drawing the Video Settings Sub-Menu
					break;
				case 1: // Drawing the Audio Settings Sub-Menu
					break;
				case 2: // Drawing the Controls Settings Sub-Menu
					break;
			}
		}
	}
}

#endregion

#region Drawing the Main Settings Menu

if (alpha > 0){
	draw_set_alpha(alpha);
	
	// The three file select options
	draw_set_font(font_gui_small);
	for (var i = 0; i < numRows; i++){
		if (i == curOption[Y]){ // Draw the highighted option as and the cursor next to it
			draw_text_outline(43, 28 + (16 * i), menuOption[0, i], selCol, selOCol);
			draw_text_outline(30, 28 + (16 * i), ">", selCol, selOCol);
		} else{ // Draw the options as normal
			draw_text_outline(43, 28 + (16 * i), menuOption[0, i], regCol, regOCol);
		}
	}
	
	// Drawing the menu option's description
	draw_set_font(font_gui_xSmall);
	
	draw_set_halign(fa_center);
	draw_text_outline(global.camWidth / 2, 4, optionDesc[0, curOption[Y]], c_white, c_gray);
	draw_set_halign(fa_left);
	
	// Reset the alpha channel to its normal value
	draw_set_alpha(1);
}

#endregion