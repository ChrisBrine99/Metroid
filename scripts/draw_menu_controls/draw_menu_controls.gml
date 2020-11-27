/// @description Draw the menu's control prompts relative to their calculated positions. The sprites for the
/// keybindings are calculated with different methods depending on the anchor they used for positioning.
/// @param sOutlineColor

function draw_menu_controls(_sOutlineColor){
	// Set the currently used font; also set the vertical alignment back to its default
	draw_set_valign(fa_top);
	outline_set_font(controlsFont, global.fontTextures[? controlsFont], sPixelWidth, sPixelHeight);

	// Set the color of the font's text and its outline
	draw_set_color(controlsTextCol);
	shader_set_uniform_f_array(_sOutlineColor, controlsOutlineCol);

	var _length, _index2D, _index3D, _spriteWidth;
	_length = ds_list_size(controlsAnchor);
	for (var i = 0; i < _length; i++){
		_index2D = i * 2;
		_index3D = i * 3;
		if (controlsAnchor[| i] == LEFT_ANCHOR){
			draw_set_halign(fa_left);
			// Draw the control information without any adjustment to the position
			draw_sprite(controlsInfo[| _index3D], controlsInfo[| _index3D + 1], controlsPos[| _index2D], controlsPos[| _index2D + 1]);
			draw_text(controlsPos[| _index2D] + (sprite_get_width(controlsInfo[| _index3D]) + 2), controlsPos[| _index2D + 1] + 2, controlsInfo[| _index3D + 2]);
		} else if (controlsAnchor[| i] == RIGHT_ANCHOR){
			draw_set_halign(fa_right);
			// Factor in the sprite's width relative to the position of the control information
			_spriteWidth = sprite_get_width(controlsInfo[| _index3D]);
			draw_sprite(controlsInfo[| _index3D], controlsInfo[| _index3D + 1], controlsPos[| _index2D] - _spriteWidth, controlsPos[| _index2D + 1]);
			draw_text(controlsPos[| _index2D] - (_spriteWidth + 1), controlsPos[| _index2D + 1] + 2, controlsInfo[| _index3D + 2]);
		}
	}
}