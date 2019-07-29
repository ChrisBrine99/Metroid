/// @description Drawing the debug menu
// You can write your code in this editor

if (alpha > 0){
	// Set the alpha level for the rectangle background
	draw_set_alpha(alpha * 0.3);
	draw_rectangle_color(global.camWidth, 0, global.camWidth - 125, global.camHeight, c_blue, c_blue, c_black, c_black, false);
	
	// Set the alpha level for the text
	draw_set_alpha(alpha);
	draw_rectangle_color(global.camWidth - 125, 0, global.camWidth - 125, global.camHeight, c_black, c_black, c_black, c_black, false);
	
	
	
	// Drawing the detailed information provided by the Debug Menu
	draw_set_font(font_gui_xSmall);
	
	draw_set_halign(fa_right);
	// Player Position Information
	draw_text_outline(global.camWidth - 5, 10, string(obj_player.x) + "\n" +
											  string(obj_player.y) + "\n", c_lime, c_green);
	// Instance Information
	draw_text_outline(global.camWidth - 5, 35, numInstances + "\n" +
											  numActiveObjects + "\n" +
											  numEntities + "\n" +
											  numActiveEntities + "\n" + 
											  numLightSources + "\n" + 
											  numDrawnLights, c_fuchsia, c_purple);
	
	draw_set_halign(fa_left);
	// Player Position Information
	draw_text_outline(global.camWidth - 120, 10, "Player X:\nPlayer Y:", c_white, c_gray);	
	// Instance Information
	draw_text_outline(global.camWidth - 120, 35, "Unculled Objects\n     Active        --\nEntities\n     Active        --\nLight Sources\n     Drawn        --", c_white, c_gray);	
	
	// Return the alpha level back to normal
	draw_set_alpha(1);
}