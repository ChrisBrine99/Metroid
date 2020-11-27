/// @description Draws the information for currently highlighted option at the position specified within the menu.
/// If the scrolling text flag is enabled, the numCharacters variable will be updated relative to the text speed
/// set within the accessibility settings.
/// @param sOutlineColor

function draw_menu_options_info(_sOutlineColor){
	// If the currently highlighted option isn't active, don't draw its information
	if (!optionActive[| curOption]){
		return;
	}

	// Set the currently used alignment and font
	draw_set_halign(infoAlign[X]);
	draw_set_valign(infoAlign[Y]);
	outline_set_font(infoFont, global.fontTextures[? infoFont], sPixelWidth, sPixelHeight);

	// Set the color of the font's text and its outline
	draw_set_color(infoTextCol);
	shader_set_uniform_f_array(_sOutlineColor, infoOutlineCol);

	if (scrollingInfoText){ // Draw the currently visible portion of the text; adding to it every frame
		var _curInfoText = string_copy(info[| curOption], 0, numCharacters);
		draw_text(infoPos[X], infoPos[Y], _curInfoText);
		numCharacters += 0.75 * global.deltaTime;
	} else{ // Draw the full string instantly if no scrolling is being used
		draw_text(infoPos[X], infoPos[Y], info[| curOption]);
	}
}