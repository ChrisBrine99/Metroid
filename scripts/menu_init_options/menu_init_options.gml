/// @description Initializes the position, font, spacing between, and alignment of the text relative to its position.
/// @param xPos
/// @param yPos
/// @param hAlign
/// @param vAlign
/// @param xSpacing
/// @param ySpacing
/// @param font

function menu_init_options(_xPos, _yPos, _hAlign, _vAlign, _xSpacing, _ySpacing, _font){
	optionPos = [_xPos, _yPos];
	optionAlign = [_hAlign, _vAlign];
	optionSpacing = [_xSpacing, _ySpacing];

	optionFont = _font;
}