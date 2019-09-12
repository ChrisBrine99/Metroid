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
			draw_sprite_ext(spr_generic_rectangle, 0, 40, 26 + (35 * i), 240, 30, 0, selRectCol, alpha * 0.3);
			draw_text_outline(43, 28 + (35 * i), menuOption[i, 0], selCol, selOCol);
			draw_text_outline(30, 28 + (35 * i), ">", selCol, selOCol);
		} else{ // Draw the options as normal
			draw_sprite_ext(spr_generic_rectangle, 0, 40, 26 + (35 * i), 240, 30, 0, rectCol, alpha * 0.3);
			draw_text_outline(43, 28 + (35 * i), menuOption[i, 0], regCol, regOCol);
		}
	}
	
	// Drawing the "Options" and "Exit Game" options
	draw_set_font(font_gui_small);
	draw_set_halign(fa_right);
	
	if (curOption[Y] != 3){ // Draw the option as normal
		draw_text_outline(279, 133, menuOption[3, 0], regCol, regOCol);
	} else{ // Draw the highlighted option and the cursor next to it
		draw_text_outline(279, 133, menuOption[3, 0], selCol, selOCol);
		draw_text_outline(220, 133, ">", selCol, selOCol);
	}
	
	if (curOption[Y] != 4){ // Draw the option as normal
		draw_text_outline(279, 149, menuOption[4, 0], regCol, regOCol);
	} else{ // Draw the highlighted option and the cursor next to it
		draw_text_outline(279, 149, menuOption[4, 0], selCol, selOCol);
		draw_text_outline(220, 149, ">", selCol, selOCol);
	}
	
	// Reset the drawing alignment back to the top left corner
	draw_set_halign(fa_left);
}

// Reset the alpha channel back to opaque
draw_set_alpha(1);