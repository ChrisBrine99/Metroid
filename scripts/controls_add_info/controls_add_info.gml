/// @description Adds control prompt information for the current menu. This information includes the sprite
/// used for the chosen keybinding, and the anchor it uses, which can be either the right or left one.
/// @param keybinding
/// @param anchor
/// @param info
/// @param calculatePositions

function controls_add_info(_keybinding, _anchor, _info, _calculatePositions){
	ds_list_add(controlsPos, 0, 0); // Every 2 indexes is one "element"
	ds_list_add(controlsAnchor, _anchor);

	var _imageData = keybinding_get_sprite(_keybinding);
	ds_list_add(controlsInfo, _imageData[0], _imageData[1], _info);

	// Finally, if needed, calculate the positions for the anchor's controls
	if (_calculatePositions){ // When initializing control info, the final index for each anchor should have this flag enabled.
		controls_calculate_position(_anchor);
	}
}