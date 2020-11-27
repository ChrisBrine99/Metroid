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

	draw_set_font(_font);
	shader_set_uniform_f(_sPixelWidth, texture_get_texel_width(_textureID));
	shader_set_uniform_f(_sPixelHeight, texture_get_texel_height(_textureID));
}
