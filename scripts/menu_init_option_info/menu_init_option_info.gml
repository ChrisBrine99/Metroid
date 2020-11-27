/// @description Initializes the position, alignment, font, and color for the text. The alignment values alter
/// how the text is displayed relative to its given position.
/// @param xPos
/// @param yPos
/// @param hAlign
/// @param vAlign
/// @param font
/// @param innerCol
/// @param outerCol[r/g/b]

function menu_init_option_info(_xPos, _yPos, _hAlign, _vAlign, _font, _innerCol, _outerCol){
	infoPos = [_xPos, _yPos];
	infoAlign = [_hAlign, _vAlign];

	infoFont = _font;
	infoTextCol = _innerCol;
	infoOutlineCol = _outerCol;
}