#region Additional string functions

/// @description A simple function that returns a single line from a given string. An offset can be provided
/// to the function in order to see out the next available line starting from that character index. 
/// @param {String}	string
/// @param {Real}	startIndex
function string_get_line(_string, _startIndex = 1){
	var _line, _curChar, _length;
	_line = "";
	_length = string_length(_string);
	for (var i = _startIndex; i <= _length; i++){ // Loop from the start index until the final character of the string.
		_curChar = string_char_at(_string, i);
		// The new line character (\n) was hit; return the current line variable's data.
		if (_curChar == "\n") {return _line;}
		_line += _curChar; // Continue adding characters until the next line character (\n) is hit.
	}
	
	// If the last line was being retrieved by the function, it won't trigger the check for the "\n" character
	// within the loop. So, return whatever the line value is here to prevent that.
	return _line;
}

/// @description A simple function that takes in a string of any length and converts it to fit within a certain
/// width by applying line breaks in between words to prevent any from exceeding the provided maximum width.
/// While there is a limit to how wide the string can be, there isn't a limit to how many lines it can contain.
/// @param {String}			string
/// @param {Real}			maxWidth
/// @param {Asset.GMFont}	usedFont
function string_format_width(_string, _maxWidth, _usedFont){
	// Overwrite whatever the previous font was in order to have accurate calculations relative to the font
	// that will be used for the supplied string. Otherwise, the calculations will use whatever the current
	// font is and the width/height values will not be accurate.
	var _previousFont = draw_get_font();
	draw_set_font(_usedFont);
	
	// After properly storing the currently in use font and replacing it with the font that is required for
	// the supplied string, begin looping through the characters and formatting it in such a way that it 
	// doesn't exceed the supplied maximum width value.
	var _newString, _curLine, _curWord, _length, _curChar;
	_newString = ""; // Initialize as empty in case the for loop doesn't execute; prevents crashing
	_curLine = "";
	_curWord = "";
	_length = string_length(_string);
	for (var i = 1; i <= _length; i++){
		_curChar = string_char_at(_string, i);
		if (i == _length || _curChar == " " || _curChar == "-"){ // Appends the new word to the string for every space/hyphen OR if it's the end of the string.
			if (string_width(_curLine + _curWord) > _maxWidth){ // Put the word onto the next line and start calculating the next line's characters.
				_newString += _curLine + "\n";
				_curLine = _curWord;
			} else{ // The word can fit onto the current line; simply add it and move onto the next word.
				if (_curLine == "") {_curLine += _curWord;}
				else {_curLine += " " + _curWord;}
			}
			_curWord = "";
			continue; // Skip over the " " character; moving onto the next available word in the string.
		}
		// If no space is detected; add the character to the variable for storing the current word.
		_curWord += _curChar;
	}
	// Add the last line and final character to the string before it's return from the function.
	_newString += _curLine + _curChar;
	
	// After exiting the loop, reset the font back to what it was before this function was called. This
	// prevents any errors specifically with the outline shader, since changing fonts without updating the
	// current texel size could cause rendering errors.
	draw_set_font(_previousFont);
	
	// Finally, return the new string; formatted in such a way that there are line breaks allowing it to fit
	// within the bounds of 0 and the "_maxWidth" argument provided by the code.
	return _newString;
}

/// @description A simple function that takes in a number and adds a specific amount of 0s to the front of that
/// number until the amount of numbers found within the formatted string matches the total amount of zeroes
/// set within the "_totalZeroes" argument space. Optionally, the number's value can be limited to the max
/// possible place values alloted by the max amount of zeroes (Ex. 1435 with a total of 3 possible zeroes 
/// would be formatted to "999" by the function).
/// @param {Real}	number
/// @param {Real}	totalZeroes
function string_number_add_zeroes(_number, _totalZeroes, _limitNumber = false){
	_number = floor(_number); // Removes any decimal values from the supplied number.
	
	// Determine how many zeroes must be added in order to complete the requirements of the function arguments.
	// This means there are three possible cases for the value: the number has more place values than available
	// zeroes and it should be limited, the number is equal to or greater than the number of zeroes and it should
	// simply be returned as a string version of the value, or there are a certain number of zeroes that will
	// be added to the front of the number to format it properly.
	var _numberAsString, _availableZeroSpaces;
	_numberAsString = string(_number);
	_availableZeroSpaces = _totalZeroes - string_length(_numberAsString);
	if (_availableZeroSpaces < 0 && _limitNumber){ // Return a repeated sequence of 9's to match the max possible value if the number is limited to a certain number of place values.
		return string_repeat("9", _totalZeroes);
	} else if (_availableZeroSpaces <= 0){ // Simply return the number as a string.
		return _numberAsString;
	} else{ // Adds zeros in front of the number to match the calculated _availableZeroSpaces value.
		return string_repeat("0", _availableZeroSpaces) + _numberAsString;
	}
}

/// @description Takes in a number (Can even be non-integer) and converts it to the standard hours/minutes/seconds
/// format for calculating time. An optional flag to allow the function to calculate milliseconds can also be
/// used, which will use whatever the current decimial's top 2 place values for it's final calculated amount.
/// @param {Real}	number
/// @param {Bool}	displayMilliseconds
function string_number_to_time_format(_number, _displayMilliseconds = false){
	// All of these calculations are stored inside of local variables for easier readability on both return
	// values found in the function. Otherwise, these would clutter what is already two cluttered lines of
	// code even further.
	var _hours, _minutes, _seconds;
	_hours = floor(_number / 3600);
	_minutes = floor((_number / 60)) % 60;
	_seconds = _number % 60;
	
	// If the number should be formatted to display the current milliseconds; calculate them by grabbing the
	// fraction value from the provided number and multiplying that by 100 since 100 milliseconds = 1 second.
	if (_displayMilliseconds){
		var _milliseconds = frac(_number) * 100;
		return string_number_add_zeroes(_hours, 2) + ":" + string_number_add_zeroes(_minutes, 2) + ":" + string_number_add_zeroes(_seconds, 2) + "." + string_number_add_zeroes(_milliseconds, 2);
	}
	
	// If there isn't a need to display milliseconds, simply copy what the first return does minus the step
	// that calculates milliseconds and the addition of that in the return line.
	return string_number_add_zeroes(_hours, 2) + ":" + string_number_add_zeroes(_minutes, 2) + ":" + string_number_add_zeroes(_seconds, 2);
}

/// @description Allows a monospaced piece of text to get the proper width for itself, which wouldn't be
/// possible with Game Maker's conventional "string_width" function unless the font is question actually was
/// monospaced to begin with. Optionally, special characters can be ignored in the monospacing just like the 
/// monospace text rendering function allows.
/// @param {String}			string
/// @param {Real}			separation
/// @param {Asset.GMFont}	usedFont
/// @param {Bool}			ignoreSpecialCharacters
function string_width_monospace(_string, _separation, _usedFont, _ignoreSpecialCharacters = false){
	// Overwrite whatever the previous font was in order to have accurate calculations relative to the font
	// that will be used for the supplied string. Otherwise, the calculations will use whatever the current
	// font is and the width/height values will not be accurate.
	var _previousFont = draw_get_font();
	draw_set_font(_usedFont);
	
	// After storing the previous font and setting up the string width/height calculations to use the accurate
	// dimensions for the string's desired font, initialize some local variables that will be useful within the
	// loop that calculates the string's width.
	var _lineWidth, _stringWidth, _length, _curChar;
	_lineWidth = 0;
	_stringWidth = 0;
	_length = string_length(_string);
	for (var i = 0; i < _length; i++){
		_curChar = string_char_at(_string, i);
		// Whenever a newline character is found within the current string, the line width variable is reset
		// in order to begin counting the width of said new line from the beginning. If the line width for
		// the one that was just counted exceeds the current string width, overwrite that value since it's
		// actually what is considered to be the width of the string. 
		if (_curChar == "\n"){
			if (_lineWidth > _stringWidth) {_stringWidth = _lineWidth;}
			_lineWidth = 0;
			continue; // Code values aren't actual displayable strings, so these characters aren't considered in the width calculations.
		}
		// If special characters are ignored for the text's monospacing, they will simply use the width they
		// were provided by the font itself. Otherwise, they and all character will use the separation value.
		if (_ignoreSpecialCharacters && is_special_character(_curChar))  {_lineWidth += string_width(_curChar);}
		else															 {_lineWidth += _separation;}
	}
	// After exiting the loop, reset the font back to what it was before this function was called. This
	// prevents any errors specifically with the outline shader, since changing fonts without updating the
	// current texel size could cause rendering errors.
	draw_set_font(_previousFont);
	
	// Once the entire string has been parsed, the largest line's width will be returned by the function.
	// However, the line width variable is what is returned instead if the string is only a single line. If
	// this didn't happen the value returned would actually be 0.
	if (string_count("\n", _string) == 0) {return _lineWidth;}
	return _stringWidth;
}

/// @description A simple function that checks to see if the supplied character is considered a "special
/// character." In short, a special character is any character that isn't an upper case letter, lower case
/// letter, number, or "code" value.
/// @param {String}	character
function is_special_character(_char){
	var _code = ord(_char); // Convert the character to it's ascii value counterpart
	return ((_code >= 20 /* " " */ && _code <= 47 /* "/" */) || (_code >= 58 /* ":" */ && _code <= 64 /* "@" */) || (_code >= 91 /* "[" */ && _code <= 96 /* "`" */) || (_code >= 123 /* "{" */ && _code <= 126 /* "~" */));
}

#endregion

#region Additional math functions

/// @description A simple function that linearly adds or subtracts a given value towards the supplied target
/// value. The speed that the value reaches said target is determined by the value in the _modifier argument
/// space--higher values leading to the value reaching its target at a faster speed.
/// @param {Real}	value
/// @param {Real}	target
/// @param {Real}	modifier
function value_set_linear(_value, _target, _modifier){
	if (_value == _target) {return _value;} // The value is already at the target number; simply return that number.
	
	// Since this is a linear calculation, there needs to be one calculation for an increasing value to a
	// target and one for a decreasing value to said target. Both will perform checks that prevent the
	// value from being greater than the target or less than the target depending on if the modifier was
	// added or subtracted from the current _value variable's value, respectively.
	if (_value < _target){ // Increasing the value towards the target at the speed set by _modifier.
		var _targetValue = _value + (_modifier * DELTA_TIME);
		if (_targetValue >= _target - _modifier)	{return _target;}
		else										{return _targetValue;}
	} else if (_value > _target){ // Decreasing the value towards the target at the speed set by _modifier.
		var _targetValue = _value - (_modifier * DELTA_TIME);
		if (_targetValue <= _target + _modifier)	{return _target;}
		else										{return _targetValue;}
	}
}

/// @description A simple function that adds or subtracts a number from a given value towards its target
/// relative to how far apart the target and original value are. The greater the distance, the faster the
/// value will be pulled toward the target, and vice versa for smaller distances.
/// @param {Real}	value
/// @param {Real}	target
/// @param {Real}	speed
function value_set_relative(_value, _target, _speed){
	if (_value == _target) {return _target;} // The value is already as the target number; simply return that number.
	
	// In order to prevent the weird effect that can occur when the value gets really close to the target and
	// begins moving in decimal increments every frame, the value will simply become the target if its rounded
	// value is equal to that target value.
	if (round(_value) == _target) {return _target;}
	
	// Calcuate the value that SHOULD be returned by the function in order to perform an important check on
	// said value. In short, if the value surpasses the target in the event of delta time being an absurdly
	// high value, it will clip that value at the target instead of letting it surpass that bound.
	var _targetValue = _value + ((_target - _value) * _speed * DELTA_TIME);
	if ((_targetValue >= _target && _value < _target) || (_targetValue <= _target && _value > _target)) {return _target;}
	return _targetValue; // If the target value doesn't go out of intended bounds, simply return the target.
}

#endregion

#region JSON functions

/// @description Simply loads in the supplied JSON file by decrypting the data into a temporary file and then
/// reading the information from that file; returning a matching data structure once the it is decoded.
/// @param {String}	filename
/// @param {String}	decryptKey
function encrypted_json_load(_filename, _decryptKey = ""){
	try{
		// TODO -- Add decryption stuff here
		
		// Load in the decrypted data from the temporarily created file; loading it in using a buffer.
		var _buffer, _bufferString;
		_buffer = buffer_load(_filename);
		_bufferString = buffer_read(_buffer, buffer_string);
		buffer_delete(_buffer); // Clear the buffer from memory after reading.
	
		// TODO -- Delete the decrypted file here
	
		// Return the decoded string that was loaded from the JSON file; returning a massive data structure
		// containing many lists within maps of lists and so on.
		return json_decode(_bufferString);
	} catch(_error){
		show_debug_message(_error.message + " in Script: " + _error.script);
	}
}

#endregion