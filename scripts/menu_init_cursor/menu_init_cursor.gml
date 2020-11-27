/// @dsescription Initializes the variables for the optional cursor. This cursor will have its position calculated
/// relative to the option's position. 
/// @param xPos
/// @param yPos
/// @param cursorSprite

function menu_init_cursor(_xPos, _yPos, _cursorSprite) {
	cursorPos = [_xPos, _yPos];
	cursorSprite = _cursorSprite;
}