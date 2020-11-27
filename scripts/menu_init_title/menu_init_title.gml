/// @description Initializes the title contents, as well as the position, font, alignment, and color of the title.
/// @param title
/// @param xPos
/// @param yPos
/// @param hAlign
/// @param vAlign
/// @param font
/// @param innerCol
/// @param outerCol[r/g/b]

function menu_init_title(_title, _xPos, _yPos, _hAlign, _vAlign, _font, _innerCol, _outerCol){
	title = _title;

	titlePos = [_xPos, _yPos];
	titleAlign = [_hAlign, _vAlign];

	titleFont = _font;
	titleTextCol = _innerCol;
	titleOutlineCol = _outerCol;
}