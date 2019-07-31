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
	
	// Setting up the string's that will display the player's weapon's current ammo and maximum ammo
	var curAmmo, maxAmmo;
	curAmmo = "---";
	maxAmmo = "---";
	if (global.maxAmmo > 0){
		// The current ammo string
		if (global.curAmmo < 10) {curAmmo = "00" + string(global.curAmmo);}
		else if (global.curAmmo < 100) {curAmmo = "0" + string(global.curAmmo);}
		else {curAmmo = string(global.curAmmo);}
		// The maximum ammo string
		if (global.maxAmmo < 10) {maxAmmo = "00" + string(global.maxAmmo);}
		else if (global.maxAmmo < 100) {maxAmmo = "0" + string(global.maxAmmo);}
		else {maxAmmo = string(global.maxAmmo);}
	}
	// Displaying the final result
	draw_set_font(font_gui_xSmall);
	draw_set_halign(fa_center);
	draw_text_outline(37, 178 - string_height("0"), curAmmo + "/" + maxAmmo, c_gray, c_dkgray);
	draw_set_halign(fa_left);
	// Displaying the weapon's icon
	draw_sprite(global.iconSpr, 0, 2, 164);
	
	// Return the alpha back to normal
	draw_set_alpha(1);
}

#endregion