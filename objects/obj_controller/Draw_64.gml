/// @description Display General Debug Info

if (!showDebugInfo){
	return;
}

shader_set(outlineShader);
shader_set_uniform_i(sDrawOutline, 1);
outline_set_font(font_gui_small, global.fontTextures[? font_gui_small], sPixelWidth, sPixelHeight);

draw_set_halign(fa_left);
shader_set_uniform_f_array(sOutlineColor, [0.5, 0.5, 0.5]);
draw_set_color(c_white);
draw_text(5, 5, "Camera Position:\nRoom Size:\n\nPlayer Position:\nPlayer Velocity:\n\nLighting Brightness:\nLighting Contrast:\nLighting Saturation:");
		
draw_set_halign(fa_right);
shader_set_uniform_f_array(sOutlineColor, [0.5, 0, 0]);
draw_set_color(c_red);
draw_text(136, 5, "[" + string(x) + ", " + string(y) + "]\n" +
				  "[" + string(room_width) + ", " + string(room_height) + "]\n\n" +
				  "[" + string(global.playerID.x) + ", " + string(global.playerID.y) + "]\n" + 
				  "[" + string(global.playerID.hspd) + ", " + string(global.playerID.vspd) + "]\n\n" +
				  string(global.effectID.lightBrightness) + "\n" +
				  string(global.effectID.lightContrast) + "\n" +
				  string(global.effectID.lightSaturation));

shader_reset();