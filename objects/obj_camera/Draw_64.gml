/// @description Draw the in-game screen elements
// You can write your code in this editor

#region Drawing the in-game HUD

if (alpha > 0){
	// Set the alpha of the HUD
	draw_set_alpha(alpha);
	
	// Drawing Samus's information
	draw_set_font(font_gui_large);
	with(obj_player) {draw_text_outline(5, 5, curHitpoints, c_white, c_gray);}
	
	// Return the alpha back to normal
	draw_set_alpha(1);
}

#endregion