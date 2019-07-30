/// @description Insert description here
// You can write your code in this editor

#region Drawing to the screen

if (alpha > 0){
	draw_sprite_ext(spr_generic_rectangle, 0, 0, 0, global.camWidth, global.camHeight, 0, c_black, alpha * 0.3);
	
	// Set the alpha level
	draw_set_alpha(alpha);
	
	draw_set_font(font_gui_xSmall);
	draw_text_outline(50, 50, "curIndex: " + string(curIndex) + "\nmenuSize: " + string(menuSize), c_white, c_gray);
	
	// Reset the alpha level
	draw_set_alpha(1);
}

#endregion