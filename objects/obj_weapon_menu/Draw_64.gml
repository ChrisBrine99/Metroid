/// @description Insert description here
// You can write your code in this editor

#region Drawing to the screen

if (alpha > 0){
	// Drawing the menu's background
	draw_rect_outline(3, 107, 210, 54, c_blue, c_black, c_black, alpha * 0.3, alpha);
	draw_sprite_general(spr_generic_rectangle, 0, 0, 0, 1, 1, 6, 120, 204, 1, 0, c_black, c_black, c_black, c_black, alpha);
	
	// Set the alpha level
	draw_set_alpha(alpha);
	
	// Displaying the menu icons
	for (var i = 0; i < numColumns; i++){
		if (curOption[X]  == i) draw_sprite(menuSprite[i, 0], 0, 2 + (i * 16), 164);
		else draw_sprite(menuSprite[i, 0], 1, 2 + (i * 16), 164);
	}
	
	// Displaying the weapon's name
	draw_set_font(font_gui_med);
	draw_text_outline(10, 110, menuOption[curOption[X], 0], c_lime, c_green);
	// Displaying the weapon's current ammo and maximum ammo
	var curAmmo, totAmmo;
	curAmmo = "---";
	totAmmo = "---";
	if (menuOptionExt[curOption[X], 2] > 0){
		// Setting up the string for the weapon's cuttent ammo
		if (menuOptionExt[curOption[X], 1] < 10) curAmmo = "00" + string(menuOptionExt[curOption[X], 1]);
		else if (menuOptionExt[curOption[X], 1] < 100) curAmmo = "0" + string(menuOptionExt[curOption[X], 1]);
		else curAmmo = string(menuOptionExt[curOption[X], 1]);
		// Setting up the string for the wepaon's maximum ammo
		if (menuOptionExt[curOption[X], 2] < 10) totAmmo = "00" + string(menuOptionExt[curOption[X], 2]);
		else if (menuOptionExt[curOption[X], 2] < 100) totAmmo = "0" + string(menuOptionExt[curOption[X], 2]);
		else totAmmo = string(menuOptionExt[curOption[X], 2]);
	}
	draw_set_font(font_gui_xSmall);
	draw_set_halign(fa_center);
	draw_text_outline(35, 123, curAmmo + "/" + totAmmo, c_gray, c_dkgray);
	draw_set_halign(fa_left);
	// Drawing the weapon's description onto the screen
	if (displayTxt != optionDesc[curOption[X], 0]){
		displayTxt = optionDesc[curOption[X], 0];
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
	draw_text_outline(7, 132, curDisplayedStr, c_white, c_gray);
	// Reset the alpha level
	draw_set_alpha(1);
}

#endregion