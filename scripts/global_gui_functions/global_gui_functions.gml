/// @description Functions relating to displaying general things that will be found on the GUI layer for the 
/// game. This includes functions like swapping the font while using the outline shader, drawing primitives
/// like rectangles, and so on.

/// @description Sets the font currently being used for drawing text on the GUI surface. Also, sets the texel 
/// size based on that font's texture page size for accurate drawing.
/// @param font
/// @param textureID
/// @param sPixelWidth
/// @param sPixelHeight
function outline_set_font(_font, _textureID, _sPixelWidth, _sPixelHeight){
	// If the font hasn't changed, don't bother resetting texel sizes since they didn't change either.
	if (draw_get_font() == _font){
		return;
	}
	// Swap the data over to the new font, update the texel size for the shader to use.
	draw_set_font(_font);
	shader_set_uniform_f(_sPixelWidth, texture_get_texel_width(_textureID));
	shader_set_uniform_f(_sPixelHeight, texture_get_texel_height(_textureID));
}

/// @description Draws a rectangle with a nice one-pixel outline around it. Drawing rectangles using 
/// draw_sprite_ext and relying on the outline shader doesn't work for some reason -- I assume it's something 
/// to do with how texture coordinates work or something... Anyway, this substitutes that and allows for a 
/// rectangle to be outlined without the use of the shader.
/// @param xPos
/// @param yPos
/// @param width
/// @param height
/// @param innerCol
/// @param outerCol
/// @param innerAlpha
/// @param outerAlpha
function draw_rect_outline(_xPos, _yPos, _width, _height, _innerCol, _outerCol, _innerAlpha, _outerAlpha){
	// Drawing outer rectangle/outer rectangles depending on alpha level
	if (_innerAlpha < 1){ // Inner rectangle is translucent/transparent; draw outline in four separate pieces
		draw_sprite_ext(spr_rectangle, 0, _xPos, _yPos, _width, 1, 0, _outerCol, _outerAlpha);							// Top outline
		draw_sprite_ext(spr_rectangle, 0, _xPos, _yPos + _height - 1, _width, 1, 0, _outerCol, _outerAlpha);			// Bottom outline
		draw_sprite_ext(spr_rectangle, 0, _xPos, _yPos + 1, 1, _height - 2, 0, _outerCol, _outerAlpha);					// Left outline
		draw_sprite_ext(spr_rectangle, 0, _xPos + _width - 1, _yPos + 1, 1, _height - 2, 0, _outerCol, _outerAlpha);	// Right outline
	} else{ // Inner rectangle is opaque, draw a single rectangle to represent the outline
		draw_sprite_ext(spr_rectangle, 0, _xPos, _yPos, _width, _height, 0, _outerCol, _outerAlpha);
	}
	// Drawing inner rectangle, which is 2 pixels smaller than the outline's size
	draw_sprite_ext(spr_rectangle, 0, _xPos + 1, _yPos + 1, _width - 2, _height - 2, 0, _innerCol, _innerAlpha);
}
