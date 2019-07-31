/// @description Insert description here
// You can write your code in this editor

#region Drawing to the screen

if (alpha > 0){
	// Drawing the menu's background
	draw_rect_outline(3, 107, 180, 54, c_blue, c_black, c_black, alpha * 0.3, alpha);
	draw_sprite_general(spr_generic_rectangle, 0, 0, 0, 1, 1, 6, 120, 174, 1, 0, c_black, c_black, c_black, c_black, alpha);
	
	// Set the alpha level
	draw_set_alpha(alpha);
	
	// Displaying the menu icons
	for (var i = 0; i < menuSize; i++){
		if (curIndex  == i) draw_sprite(weaponInfo[i, 0], 0, 2 + (i * 16), 164);
		else draw_sprite(weaponInfo[i, 0], 1, 2 + (i * 16), 164);
	}
	
	// Displaying the weapon's name
	draw_set_font(font_gui_med);
	draw_text_outline(10, 110, weaponInfo[curIndex, 1], c_lime, c_green);
	// Displaying the weapon's current ammo and maximum ammo
	var curAmmo, totAmmo;
	curAmmo = "---";
	totAmmo = "---";
	if (weaponInfo[curIndex, 5] > 0){
		// Setting up the string for the weapon's cuttent ammo
		if (weaponInfo[curIndex, 4] < 10) curAmmo = "00" + string(weaponInfo[curIndex, 4]);
		else if (weaponInfo[curIndex, 4] < 100) curAmmo = "0" + string(weaponInfo[curIndex, 4]);
		else curAmmo = string(weaponInfo[curIndex, 4]);
		// Setting up the string for the wepaon's maximum ammo
		if (weaponInfo[curIndex, 5] < 10) totAmmo = "00" + string(weaponInfo[curIndex, 5]);
		else if (weaponInfo[curIndex, 5] < 100) totAmmo = "0" + string(weaponInfo[curIndex, 5]);
		else totAmmo = string(weaponInfo[curIndex, 5]);
	}
	draw_set_font(font_gui_xSmall);
	draw_set_halign(fa_center);
	draw_text_outline(35, 123, curAmmo + "/" + totAmmo, c_gray, c_dkgray);
	draw_set_halign(fa_left);
	// Displaying the weapon's description
	draw_text_outline(7, 132, "This is a test description to see how\nmuch text I can fit in these constraints.", c_white, c_gray);
	
	// Reset the alpha level
	draw_set_alpha(1);
}

#endregion