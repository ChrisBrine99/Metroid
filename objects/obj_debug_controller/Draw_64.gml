/// @description Drawing the debug menu
// You can write your code in this editor

if (alpha > 0){
	// Drawing the Debug Menu's background
	draw_sprite_general(spr_generic_rectangle, 0, 0, 0, 1, 1, global.camWidth - 125, 0, 125, global.camHeight, 0, c_blue, c_blue, c_black, c_black, alpha * 0.3);
	draw_sprite_ext(spr_generic_rectangle, 0, global.camWidth - 125, 0, 1, global.camHeight, 0, c_black, alpha);

	// Set the alpha level for the text
	draw_set_alpha(alpha);
	
	// Drawing the detailed information provided by the Debug Menu
	draw_set_font(font_gui_xSmall);
	
	draw_set_halign(fa_right);
	// Camera Position Information
	draw_text_outline(global.camWidth - 5, 10, string(obj_camera.x) + "\n" +
											   string(obj_camera.y) + "\n" +
											   string(floor(global.camX)) + "\n" + 
											   string(floor(global.camY)) + "\n", c_red, c_maroon);
	// Player Position Information
	draw_text_outline(global.camWidth - 5, 50, string(obj_player.x) + "\n" +
											   string(obj_player.y) + "\n" +
											   string(obj_player.hspd) + "\n" +
											   string(obj_player.vspd), c_lime, c_green);
	// Instance Information
	draw_text_outline(global.camWidth - 5, 90, numInstances + "\n" +
											   numActiveObjects + "\n" +
											   numEntities + "\n" +
											   numActiveEntities + "\n" + 
											   numDrawnEntities + "\n" +
											   numLightSources + "\n" + 
											   numDrawnLights, c_fuchsia, c_purple);
											   
	// Delta Time Information
	draw_text_outline(global.camWidth - 5, 150, string(global.deltaTime), c_red, c_maroon);
	
	// Control Information
	draw_text_outline(global.camWidth - 5, 162, "Change BGM -- [M]\nExit Menu -- [D]", c_white, c_gray);
	
	draw_set_halign(fa_left);
	// Camera Position Information
	draw_text_outline(global.camWidth - 120, 10, "Camera X (True):\nCamera Y (True):\n     Top-Left X\n     Top-Left Y", c_white, c_gray);
	draw_text_outline(global.camWidth - 42, 10, "\n\n--\n--", c_white, c_gray);
	// Player Position Information
	draw_text_outline(global.camWidth - 120, 50, "Player X:\nPlayer Y:\n     Hspeed\n     Vspeed", c_white, c_gray);	
	draw_text_outline(global.camWidth - 42, 50, "\n\n--\n--", c_white, c_gray);
	// Instance Information
	draw_text_outline(global.camWidth - 120, 90, "Unculled Objects\n     Active\nEntities\n     Active\n     Drawn\nLight Sources\n     Drawn", c_white, c_gray);	
	draw_text_outline(global.camWidth - 42, 90, "\n--\n\n--\n--\n\n--", c_white, c_gray);
	
	// Delta Time Information
	draw_text_outline(global.camWidth - 120, 150, "Delta Time", c_white, c_gray);
	
	// Return the alpha level back to normal
	draw_set_alpha(1);
}