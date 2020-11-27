/// @description Calculates the positional offsets relative to the given anchor position. Allows for dynamically
/// updating control prompt information during runtime.
/// @param anchor

function controls_calculate_position(_anchor){
	var _anchorPos = [0, 0];
	// Get the desired anchor position based on the _anchor value
	if (_anchor == LEFT_ANCHOR){
		_anchorPos = leftAnchor;
	} else if (_anchor == RIGHT_ANCHOR){
		_anchorPos = rightAnchor;
	}

	// Set the control font to be used for accurate calculations
	draw_set_font(controlsFont);

	// Loop through all available control information and calculate the positions of them relative to the anchor
	// they are locked to.
	var _length, _offset;
	_length = ds_list_size(controlsAnchor);
	_offset = 0;
	for (var i = 0; i < _length; i++){
		if (controlsAnchor[| i] != _anchor){
			continue; // Skip calculating positions for the opposite anchor
		}
	
		// Calculate the positional offset relative to the anchor's position and if its the right or left anchor
		controlsPos[| i * 2] = _anchorPos[X] + (_offset * -_anchor);
		controlsPos[| (i * 2) + 1] = _anchorPos[Y];
	
		// Update the offset values with the new control information that has been added
		_offset += sprite_get_width(controlsInfo[| i * 3]) + 1;
		if (controlsInfo[| (i * 3) + 2] != ""){ // Don't add an empty text field's width to the offset
			_offset += string_width(controlsInfo[| (i * 3) + 2]) + 6;
		}
	}
}