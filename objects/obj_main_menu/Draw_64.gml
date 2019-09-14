/// @description Drawing the Menu
// You can write your code in this editor

draw_set_alpha(alpha);

if (alpha > 0){
	// Come helpful variables to keep the rest of the code a little cleaner looking
	var regCol, regOCol, selCol, selOCol, rectCol, selRectCol;
	regCol = c_gray;
	regOCol = c_dkgray;
	selCol = c_lime;
	selOCol = c_green;
	rectCol = make_color_rgb(20, 20, 20);
	selRectCol = make_color_rgb(50, 50, 50);
	
	// The three file select options
	draw_set_font(font_gui_xSmall);
	for (var i = 0; i <= 2; i++){
		if (i == curOption[Y]){ // Draw the highighted option as and the cursor next to it
			draw_sprite_ext(spr_generic_rectangle, 0, 40, 30 + (35 * i), 240, 30, 0, selRectCol, alpha * 0.3);
			draw_text_outline(43, 32 + (35 * i), menuOption[0, i], selCol, selOCol);
			draw_text_outline(30, 32 + (35 * i), ">", selCol, selOCol);
		} else{ // Draw the options as normal
			draw_sprite_ext(spr_generic_rectangle, 0, 40, 30 + (35 * i), 240, 30, 0, rectCol, alpha * 0.3);
			draw_text_outline(43, 32 + (35 * i), menuOption[0, i], regCol, regOCol);
		}
	}
	
	// Drawing the menu option's description
	draw_set_halign(fa_center);
	draw_text_outline(global.camWidth / 2, 5, optionDesc[0, curOption[Y]], c_white, c_gray);
	
	// Drawing the "Options" and "Exit Game" options
	draw_set_font(font_gui_small);
	draw_set_halign(fa_right);
	
	if (curOption[Y] != 3){ // Draw the option as normal
		draw_text_outline(279, 137, menuOption[0, 3], regCol, regOCol);
	} else{ // Draw the highlighted option and the cursor next to it
		draw_text_outline(279, 137, menuOption[0, 3], selCol, selOCol);
		draw_text_outline(220, 137, ">", selCol, selOCol);
	}
	
	if (curOption[Y] != 4){ // Draw the option as normal
		draw_text_outline(279, 153, menuOption[0, 4], regCol, regOCol);
	} else{ // Draw the highlighted option and the cursor next to it
		draw_text_outline(279, 153, menuOption[0, 4], selCol, selOCol);
		draw_text_outline(220, 153, ">", selCol, selOCol);
	}
	
	// Reset the drawing alignment back to the top left corner
	draw_set_halign(fa_left);
}

// Reset the alpha channel back to opaque
draw_set_alpha(1);

if (transitionObj != noone)
draw_text_outline(5, 20, string(transitionObj.alpha), c_white, c_gray);