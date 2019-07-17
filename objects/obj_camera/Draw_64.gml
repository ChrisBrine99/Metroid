/// @description Draw the in-game HUD
// You can write your code in this editor

// Draw everything for the HUD below this comment ////////////////////////////////////////////////

if (alpha > 0){
	// Set the alpha of the HUD
	draw_set_alpha(alpha);
	
	// Drawing Samus's information
	draw_set_font(font_gui_large);
	//with(obj_player) {draw_text_outline(5, 5, curHitpoints, c_white, c_gray);}
	
	draw_set_font(font_gui_small);
	draw_text_outline(5, 25, "Instances: " + string(instance_number(all)), c_white, c_gray);
	
	// Return the alpha back to normal
	draw_set_alpha(1);
}

show_debug_overlay(true);

//////////////////////////////////////////////////////////////////////////////////////////////////