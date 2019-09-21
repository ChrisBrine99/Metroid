/// @description Drawing the Settings Menu
// You can write your code in this editor

#region Initializing Local Variables and the Drawing Surface

// Some helpful variables to keep the rest of the code a little cleaner looking
var regCol, regOCol, selCol, selOCol;
regCol = c_gray;
regOCol = c_dkgray;
selCol = c_lime;
selOCol = c_green;

// Create the surface and set it to be drawn to
if (!surface_exists(menuSurf)){
	menuSurf = surface_create(global.camWidth, global.camHeight);
}

#endregion

#region Drawing the Requied Sub-Menu

if (subMenu != noone){
	var selOption = selectedOption[X] * numColumns + selectedOption[Y];
	with(subMenu){
		if (alpha > 0){
			draw_set_font(font_gui_xSmall);
			var optionVal = array_create(1, "---");
			switch(selOption){
				case 0: // Drawing the menu options for the Video Options
					optionVal = array_create(numRows, "---");
					optionVal[0] = string(global.oVideo[0]) + "x (" + string(global.camWidth * global.oVideo[0]) + " x " + string(global.camHeight * global.oVideo[0]) + ")";
					optionVal[1] = draw_bool_text(global.oVideo[1], "On", "Off");
					optionVal[2] = draw_bool_text(global.oVideo[2], "On", "Off");
					if (global.oVideo[3] > 300) {optionVal[3] = "Unlimited";}
					else {optionVal[3] = string(global.oVideo[3]);}
					optionVal[4] = draw_bool_text(global.oVideo[4], "On", "Off");
					optionVal[5] = draw_bool_text(global.oVideo[5], "On", "Off");
					break;
				case 1:
					optionVal = array_create(numRows, "---");
					for (var i = 0; i < numRows - 1; i++){
						optionVal[i] = string(global.oAudio[i]) + "%";
					}
					optionVal[numRows - 1] = draw_bool_text(global.oAudio[numRows - 1], "True", "False");
					break;
				case 2:
					break;
			}
			
			draw_set_halign(fa_right);
			// Drawing the option values to the screen
			for (var i = firstDrawn[Y]; i < firstDrawn[Y] + numToDraw[Y]; i++){
				draw_text_outline(global.camWidth - 10, yPos + 1 + ((i - firstDrawn[Y]) * 16), optionVal[i], c_fuchsia, c_purple);
			}
			draw_set_halign(fa_left);
		}
	}
}

#endregion

#region Drawing the Main Settings Menu

surface_set_target(menuSurf);
draw_clear_alpha(c_white, 0);
draw_set_alpha(alpha);

if (alpha > 0){
	// The five options for the settings menu
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
}

// Reset the alpha channel to its normal value
draw_set_alpha(1);

#endregion

#region Drawing the Surface to the Screen

surface_reset_target();
draw_surface(menuSurf, xOffset, 0);

#endregion