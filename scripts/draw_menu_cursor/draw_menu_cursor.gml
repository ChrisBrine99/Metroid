/// @description Draws the cursors position relative to the option's position. It's important to draw the cursor
/// before activating the menu's shader otherwise adverse effects may occur. No arguments needed.

function draw_menu_cursor(){
	var _xPosition, _yPosition;
	_xPosition = (cursorPos[X] + optionPos[X]) + ((curOption % menuDimensions[X]) * optionSpacing[X]);
	_yPosition = (cursorPos[Y] + optionPos[Y]) + (floor(curOption / (menuDimensions[X] * menuDimensions[Y])) * optionSpacing[Y]);

	draw_sprite(cursorSprite, 0, _xPosition, _yPosition);
}