/// @description Draws the title for the current menu using the outline shader that should be set BEFORE
/// this function is called.
/// @param sOutlineColor

function draw_menu_title(_sOutlineColor){
	// Set the currently used alignment and font
	draw_set_halign(titleAlign[X]);
	draw_set_valign(titleAlign[Y]);
	outline_set_font(titleFont, global.fontTextures[? titleFont], sPixelWidth, sPixelHeight);

	// Next, set the colors used for the inside and outline
	draw_set_color(titleTextCol);
	shader_set_uniform_f_array(_sOutlineColor, titleOutlineCol);

	// Finally, display the title at its set position
	draw_text(titlePos[X], titlePos[Y], title);
}