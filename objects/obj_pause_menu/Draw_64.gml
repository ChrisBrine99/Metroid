/// @description Insert description here
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

#region Drawing the Main Settings Menu

surface_set_target(menuSurf);
draw_clear_alpha(c_white, 0);
draw_set_alpha(alpha);

if (alpha > 0){
	// Draw the map onto the pause menu surface
	draw_map(150, 40, global.mapPosX - 6, global.mapPosY - 6, 13, 13);

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