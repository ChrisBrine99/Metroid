/// @description Draw the in-game screen elements
// You can write your code in this editor

#region Drawing the in-game HUD

if (alpha > 0){
	// Set the alpha of the HUD
	draw_set_alpha(alpha);
	
	// Drawing Samus's information
	draw_set_font(font_gui_large);
	with(obj_player){
		// Samus's Current Health
		if (curHitpoints >= 10) {draw_text_outline(3, 3, curHitpoints, c_white, c_gray);}
		else {draw_text_outline(3, 3, "0" + curHitpoints, c_white, c_gray);}
		// Samus's Current and Maximum Energy Tanks
		if (maxLives > 0){
			var xOffset, yOffset;
			yOffset = 0;
			xOffset = 0;
			if (maxLives <= 6) {yOffset = 4;}
			for (var i = 0; i < maxLives; i++){
				if (i < curLives) {draw_sprite(spr_energy_tank_gui, 0, 33 + xOffset, 3 + yOffset);}
				else {draw_sprite(spr_energy_tank_gui, 1, 33 + xOffset, 3 + yOffset);}
				// Shifting the coordinates of drawing lives to the next position
				if (i != 5){
					xOffset += 8;
				} else{
					yOffset += 8;
					xOffset = 0;
				}
			}
		}
	}
	
	// Return the alpha back to normal
	draw_set_alpha(1);
}

#endregion