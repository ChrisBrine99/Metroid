#region Object collision functions with extended functionality

/// @description An extension of the standard "place_meeting" function that allows for three-dimensional
/// collision checks to occur within a wholly 2D game. It does so by turning the z-axis values into another
/// rectangle check that is done within the horizontal space, but it will look like 3D exists in the game.
/// @param {Real}			x
/// @param {Real}			y
/// @param {Real}			z
/// @param {Asset.GMObject}	object
function place_meeting_3d(_x, _y, _z, _object){
	// Create some variables that will be referenced later in the code--for both seeing if a collision has
	// been detected (This is a combination of both "_xyMeeting" and "_zMeeting"'s results from the function.
	// The horizontal collision check is done as the first thing within the function; storing its result in
	// the "_xyMeeting" variable.
	var _xyMeeting, _zHeight, _zMeeting;
	_xyMeeting = instance_place(_x, _y, _object);
	_zHeight = zHeight;
	_zMeeting = false;
	
	// Only bother checking for a Z collision if there was a collision detected with Game Maker's standard
	// 2D collision code. This will then compare the z-axis information of both colliding objects to see
	// if a collision was found; returning "true" or "false" depending on that condition.
	if (_xyMeeting){
		with(_xyMeeting) {_zMeeting = rectangle_in_rectangle(0, z, 1, z - zHeight, 0, _z, 1, _z - _zHeight);}
	}
	
	// Returns if a collision has been detected on both the horizontal axis (The standard Game Maker collision
	// check) AND the fake z-axis. (This is done using the "rectangle_in_rectangle" check with both instance's
	// z values and their heights along said axis) Both must be true for a collision to be true.
	return (_xyMeeting && _zMeeting);
}

#endregion

#region Audio functions with extended functionality

/// @description An extension of the "audio_play_sound" function that simply adds the ability to stop any
/// previous instance of the sound effect that is being called to begin playing should that be necessary.
/// @param {Asset.GMSound}	sound			The sound resource to play.
/// @param {Real}			priority		Set the channel priority for the sound.
/// @param {Bool}			loop			Toggle the sound to play once or repeat indefinitely.
/// @param {Bool}			stopPrevious	Stop any previous instances of the sound from playing or not.
///	@param {Real}			soundType		What "group" the sound effect falls under (Music, General, UI, etc.).
/// @param {Real}			gain			Set the volume of the sound (Default is 1.0).
/// @param {Real}			offset			The offset position (in seconds) of the sound to begin its playback at.
/// @param {Real}			pitch			Set the pitch of the sound relative to its default value (1.0). 
function play_sound_effect(_sound, _priority, _loop, _stopPrevious, _soundType, _gain = 1.0, _offset = 0.0, _pitch = 1.0){
	if (_stopPrevious && audio_is_playing(_sound))
		audio_stop_sound(_sound);
	return audio_play_sound(_sound, _priority, _loop, 
				_gain * game_get_group_volume(_soundType), _offset, _pitch);
}

/// @description An extension of the "audio_play_sound_at" function that simply adds the ability to stop any
/// previous instance of the sound effect that is being called to begin playing should that be necessary.
///	@param {Id.AudioEmitter}	emitter			The index of emitter to play the sound effect on.
/// @param {Asset.GMSound}		sound			The index of sound resource to play.
/// @param {Real}				refDistance		The "Reference" distance for when the sound should begin falling off.
///	@param {Real}				maxDistance		The maximum distance that the sound will be audible from.
/// @param {Real}				falloffFactor	How fast the volume decreases between ref and max distances.
/// @param {Real}				priority		Set the channel priority for the sound.
/// @param {Bool}				loop			Toggle the sound to play once or repeat indefinitely.
/// @param {Bool}				stopPrevious	Stop any previous instances of the sound from playing or not.
///	@param {Real}				soundType		What "group" the sound effect falls under (Music, General, UI, etc.).
/// @param {Real}				gain			Set the volume of the sound (Default is 1.0).
/// @param {Real}				offset			The offset position (in seconds) of the sound to begin its playback at.
/// @param {Real}				pitch			Set the pitch of the sound relative to its default value (1.0). 
function play_sound_effect_on(_emitter, _sound, _refDistance, _maxDistance, _falloffFactor, _priority, _loop, _stopPrevious, _soundType, _gain = 1.0, _offset = 0.0, _pitch = 1.0){
	if (_stopPrevious && audio_is_playing(_sound))
		audio_stop_sound(_sound);
	return audio_play_sound_on(_emitter, _sound, _loop, _priority, _gain * game_get_group_volume(_soundType), 
				_offset, _pitch, audio_emitter_get_listener_mask(_emitter));
}

#endregion

#region Text rendering functions with extended functionality

/// @description A simple function that allows both axes of text alignment to be altered with a single line
/// of code; removing clutter from the already cluttered drawing events that Game Maker inevitably achieves.
/// @param {Constant.HAlign}	halign
/// @param {Constant.VAlign}	valign
function draw_set_text_align(_hAlign, _vAlign){
	draw_set_halign(_hAlign);
	draw_set_valign(_vAlign);
}

/// @description A simple function that condenses the reset for both the horizontal and vertical text 
/// alignment (Back to fa_left and fa_top, respectively) into a single, more readable, line of code instead 
/// of the two calls necessary to reset them normally.
function draw_reset_text_align(){
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
}

/// @description Renders a string of text onto the screen, but with a one-pixel outline relative to what a
/// "pixel" if for the current string--altered by how large or small the scaling factors on both axes. In
/// short, it will use the outline shader to render the text with an outline onto the screen at the given
/// coordinates; scaling and rotating being possible, but optional.
/// @param {Real}			x
/// @param {Real}			y
/// @param {String}			string
/// @param {Constant.Color}	innerColor
/// @param {Array<Real>}	outerColor[r/g/b]
/// @param {Real}			alpha
/// @param {Real}			xScale
/// @param {Real}			yScale
/// @param {Real}			angle
function draw_text_outline(_x, _y, _string, _innerColor, _outerColor, _alpha, _xScale = 1, _yScale = 1, _angle = 0){
	outline_set_color(_outerColor); // Sets the correct color to be used by the outline shader
	draw_text_transformed_color(_x, _y, _string, _xScale, _yScale, _angle, _innerColor, _innerColor, _innerColor, _innerColor, _alpha);
}

/// @description Renders a string of text onto the screen, but uses a set separation value for each character
/// instead of their unique width values. Allows quickly changing values like timers and such from quivering
/// and shaking as the number values change since each number has a different width with most fonts. An option
/// can be toggled to ignore special characters and use their character's spacing instead of the monospacing.
/// This allows things like timers and other number/special character based values not have odd spacing.
/// @param {Real}			x
/// @param {Real}			y
/// @param {Real}			separation
/// @param {String}			string
/// @param {Constant.Color}	innerColor
/// @param {Array<Real>}	outerColor
/// @param {Real}			alpha
/// @param {Real}			xScale
/// @param {Real}			yScale
/// @param {Real}			angle
/// @param {Bool}			ignoreSpecialCharacters
function draw_text_outline_monospaced(_x, _y, _separation, _string, _innerColor, _outerColor, _alpha, _xScale = 1, _yScale = 1, _angle = 0, _ignoreSpecialCharacters = false){
	// Outside of the loop, set the color for the string since none of the characters can change color
	// during the rendering loop; saving time instead of placing this within the loop.
	outline_set_color(_outerColor);
	
	// Create some variables to store important data about the program's current text alignment settings which
	// will determine how the monospaced text is rendered relative to the x and y position arguments. Also,
	// get and store the height of the text since it doesn't change from line to line.
	var _curHAlign, _curVAlign, _currentFont, _monospaceHeight;
	_curHAlign = draw_get_halign();
	_curVAlign = draw_get_valign();
	_currentFont = draw_get_font();
	_monospaceHeight = string_height("M") * _yScale;

	// Calculate the initial alignment offset based on the current horizontal text alignment. If it's centered,
	// the text will be aligned to half the current line's width. (This value changes for every new line that
	// is rendered within the loop) The same is true for right-aligned text aside from it offseting by the
	// entire with of the line instead of just half.
	var _alignOffsetX = 0;
	if (_curHAlign == fa_right)			{_alignOffsetX = -string_width_monospace(string_get_line(_string), _separation, _currentFont, _ignoreSpecialCharacters) * _xScale;}
	else if (_curHAlign == fa_center)	{_alignOffsetX = -floor(string_width_monospace(string_get_line(_string), _separation, _currentFont, _ignoreSpecialCharacters) * _xScale / 2);}
	draw_set_halign(fa_left); // Temporaryily set the horizontal alignment to its default for proper rendering.
	
	// Exactly like above, the offset is calculated based on the current text alignment, but for the vertical
	// alignment and y position instead. However, these values aren't changed on a per-line basis like the
	// x offset is because the height of the text can't change every line, but the width can.
	var _alignOffsetY = 0;
	if (_curVAlign == fa_bottom)		{_alignOffsetY = -string_height(_string) * _yScale;}
	else if (_curVAlign == fa_middle)	{_alignOffsetY = -floor(string_height(_string) * _yScale / 2);}
	draw_set_valign(fa_top); // Temporarily set the vartical alignment to its default for proper rendering.
	
	// Loop through the entire string; placing each character in the correct place within the monospacing's
	// width value (The third argument field in the function) If the "ignore special characters" flag is set
	// to true, the monospace width will not be applied to those characters.
	var _length, _offsetX, _offsetY, _curChar;
	_length = string_length(_string);
	_offsetX = 0;
	_offsetY = 0;
	for (var i = 1; i <= _length; i++){
		// Get the current character at the position i within the string. (i ranges from 1 to the length of
		// the provided string) From here, text rendering and new line logic can commence.
		_curChar = string_char_at(_string, i);
		if (_curChar == "\n"){ // 
			if (_curHAlign == fa_right){ // Overwrite the previous alignment by getting the width of the next line in the string.
				_alignOffsetX = -string_width_monospace(string_get_line(_string, i + 1), _separation, _currentFont, _ignoreSpecialCharacters) * _xScale;
			} else if (_curHAlign == fa_center){ // The same effect as above, but it only aligns for half the width; centering the next line properly.
				_alignOffsetX = -floor(string_width_monospace(string_get_line(_string, i + 1), _separation, _currentFont, _ignoreSpecialCharacters) * _xScale / 2);
			}
			_offsetX = 0; // Reset the character offset and push the y offset down to a new line.
			_offsetY += _monospaceHeight;
			continue;
		}
		
		// Display the character at the current character offset and string alignment offset values. Then, add
		// the _separation variable's value to the width OR the character's actual width if ignoring special
		// characters is being applied to the string and it happens to be a special character currently. If
		// that isn't the case, the former option of using the _separation value is applied instead.
		draw_text_transformed_color(_x + _offsetX + _alignOffsetX, _y + _offsetY + _alignOffsetY, _curChar, _xScale, _yScale, _angle, _innerColor, _innerColor, _innerColor, _innerColor, _alpha);
		if (_ignoreSpecialCharacters && is_special_character(_curChar))	{_offsetX += string_width(_curChar) * _xScale;}
		else															{_offsetX += _separation * _xScale;}
	}
	
	// Finally, reset the text alignment to what it prviously was in order to preserve proper text alignment
	// after this function has completed since it temporarily alters the values.
	draw_set_text_align(_curHAlign, _curVAlign);
}

/// @description Displays a numerical value to the screen, but using a sprite instead of the game's generic fonts.
/// The sprite must be formatted in to the of 0-9 to match the frame numbers. Otherwise, the values shown for the
/// numerical value will be wrong.
/// @param {Real}			x			Horizontal position to display the value at on screen.
/// @param {Real}			y			Vertical position to display the value at on screen.
/// @param {Real}			value		The value taht will be converted into a graphical representation based on the chosen sprite.
/// @param {Asset.GMSprite}	sprite		The sprite images that will use to represent the number drawn onto the screen.
/// @param {Real}			color		Color blending to apply to the text.
/// @param {Real}			totalPVs	The total number of place values within the number (0s are rendered for place values above the current value).
/// @param {Real}			spacing		Amount in pixels between each place value required for the number. 
/// @param {Real}			scale		Scaling of the text on screen along both axes.
/// @param {Real}			alpha		Overall opacity of the sprites drawn onto the screen.
function draw_number_as_sprite(_x, _y, _value, _sprite, _color = HEX_WHITE, _totalPVs = 0, _spacing = 1, _scale = 1, _alpha = 1){
	var _spriteWidth = sprite_get_width(_sprite);
	var _totalWidth = (_spriteWidth + _spacing) * _scale * _totalPVs;
	var _offset = _totalWidth;
	var _remainder = 0;
	
	var _limit = power(10, _totalPVs) - 1; // Returns a value that will be 9s repeating for the total number of place values.
	if (_value > _limit) {_value = _limit;}
	
	for (var i = 0; i < _totalPVs; i++){
		_remainder = _value % 10;
		_offset	-= (_spriteWidth + _spacing) * _scale; // Calculate number's positional offset on screen before it's drawn (It starts at the 1/10ths place value position, which is the "total width").
		draw_sprite_ext(_sprite, _remainder, _x + _offset, _y, _scale, _scale, 0, _color, _alpha);
		if (_value > 0) {_value = floor(_value * 0.1);}
	}
	
	return _totalWidth; // Return the width in pixels of the drawn value if required by the GUI element using the function.
}

#endregion

#region Sprite rendering functions with extended functionality

/// @description A simple function that automates the process for drawing a sprite that is feathered along 
/// its edges. On top of that, it also automatically sets the current shader to be the feathering one if that
/// shader wasn't already applied prior to this function's use. The two XY pairs determines after what region
/// will the feathering begin on the sprite's texture itself; with its edges being where the alpha is zero.
/// @param {Asset.GMSprite}	sprite
/// @param {Real}			imageIndex
/// @param {Real}			xPos
/// @param {Real}			yPos
/// @param {Real}			width
/// @param {Real}			height
/// @param {Real}			x1
/// @param {Real}			y1
/// @param {Real}			x2
/// @param {Real}			y2
/// @param {Real}			angle
/// @param {Constant.Color}	color
/// @param {Real}			alpha
function draw_sprite_feathered(_sprite, _imageIndex, _xPos, _yPos, _width, _height, _x1, _y1, _x2, _y2, _angle, _color, _alpha){
	// Automatically set the target rendering shader to the feathering shader if it wasn't already done
	// prior to this function being called; mainly for convenience purposes and cleaning overall code.
	if (shader_current() != shd_feathering) 
		shader_set(shd_feathering);
	
	// First, calculate the true with and height by dividing the values placed in the argument fields by the
	// actual base width and height of the sprite itself; getting how much it needs to be scaled on both axes
	// in order to achieve those desired width and height.
	var _trueWidth, _trueHeight;
	_trueWidth = _width / sprite_get_width(_sprite);
	_trueHeight = _height / sprite_get_height(_sprite);
	
	// Finally, plug the values from the two XY pairs in for the beginning bounds of the fade while also
	// plugging in the position and dimensions of the sprite's image for the ending bounds of the feathering
	// effect. Then, draw the sprite after all that has been finished to apply the effect.
	feathering_set_bounds(_x1, _y1, _x2, _y2, _xPos, _yPos, _xPos + _trueWidth, _yPos + _trueHeight);
	draw_sprite_ext(_sprite, _imageIndex, _xPos, _yPos, _trueWidth, _trueHeight, _angle, _color, _alpha);
}

#endregion