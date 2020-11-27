/// @description Takes the input string and splits it into multiple lines based on the maximum width value.
/// @param string
/// @param font
/// @param maxWidth	

function string_split_lines(_string, _font, _maxWidth) {
	// Set the font to the one that will be used for accurate calculations
	draw_set_font(_font);

	// Loop through the entire string, adding each word to the _newString value until the line's width surpasses the maximum value provided
	var _curChar, _curWord, _curLine, _newString, _length;
	_curWord = "";
	_newString = "";
	_curLine = "";
	_length = string_length(_string);
	for (var i = 1; i <= _length; i++){
		_curChar = string_char_at(_string, i);
		if (_curChar == " "){ // If there is a space, check if adding the next word will cause the line to pass its maximum allowed width
			if (string_width(_curLine + _curWord) >= _maxWidth){
				_newString += _curLine + "\n";
				_curLine = ""; // Reset on every line added
			}
			_curLine += _curWord + _curChar;
			_curWord = ""; // Reset on every word added
			continue;
		}
		_curWord += _curChar;
	}
	// Add the final word/line to the resulting string
	if (string_width(_curLine + _curWord) >= _maxWidth){ // Place the last word on a new line since it exceeds the bounds
		_newString += _curLine + "\n" + _curWord;
	} else{ // The line and word put together don't exceed the string's bounds
		_newString += _curLine + _curWord;
	}

	return _newString;
}
