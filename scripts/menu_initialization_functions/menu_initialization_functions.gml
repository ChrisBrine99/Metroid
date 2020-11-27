/// @description Functions that should be called within children of par_menu during the CREATION of the object.
/// Any other time could cause issues. (Especially using menu_initialize in anything other than the create
/// event...) They initialize each basic aspect of a menu: the options, option information, control information,
/// cursor, and so on.

/// @description Initializes the basic elements that are required for the menu to function properly. Otherwise, input
/// will not be allowed and it'll more than likely crash the game.
/// @param transition
/// @param transitionArgs[]
/// @param menuWidth
/// @param columnsDrawn
/// @param rowsDrawn
/// @param scrollOffsetX
/// @param scrollOffsetY
/// @param timeToHold
/// @param autoScrollSpeed
function menu_initialize(_transition, _transitionArgs, _menuWidth, _columnsDrawn, _rowsDrawn, _scrollOffsetX, _scrollOffsetY, _timeToHold, _autoScrollSpeed){
	// Carry over the transition to perform and arguments needed for said transition
	transition = _transition;
	transitionArgs = _transitionArgs;

	// The width of the menu to allow for 2D or 1D menus, depending on the total width. The value can only be a 
	// value of one or greater.
	menuDimensions = [max(1, _menuWidth), 0];

	// The number of rows visible to the user at once and the offset needed to scroll the visible portion of the
	// menu. The values for both must be one or above and zero or above, respectively.
	numDrawn = [clamp(_columnsDrawn, 1, menuDimensions[X]), max(1, _rowsDrawn)];
	scrollOffset = [max(0, _scrollOffsetX), max(0, _scrollOffsetY)];

	// The speed of the cursor whenever it is automatically scrolling through the options. The values for both
	// must be greater than 5 (60 = 1 second of real time) and 0.01 (smaller values = faster), respectively.
	timeToHold = max(5, _timeToHold);
	autoScrollSpeed = max(0.01, _autoScrollSpeed);

	// The first drawn vector will always be set to [0, 0] upon initialization
	firstDrawn = [0, 0];
}

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

/// @description Initializes the position of the left and right anchor for the controls to be positioned with. Also determines 
/// the color and font used for control information.
/// @param lAnchorXPos
/// @param lAnchorYPos
/// @param rAnchorXPos
/// @param rAnchorYPos
/// @param font
/// @param innerCol
/// @param outerCol[r/g/b]
function menu_init_control_info(_lAnchorXPos, _lAnchorYPos, _rAnchorXPos, _rAnchorYPos, _font, _innerCol, _outerCol){
	rightAnchor = [_rAnchorXPos, _rAnchorYPos];
	leftAnchor = [_lAnchorXPos, _lAnchorYPos];

	controlsFont = _font;
	controlsTextCol = _innerCol;
	controlsOutlineCol = _outerCol;
}

/// @dsescription Initializes the variables for the optional cursor. This cursor will have its position calculated
/// relative to the option's position. 
/// @param xPos
/// @param yPos
/// @param cursorSprite
function menu_init_cursor(_xPos, _yPos, _cursorSprite) {
	cursorPos = [_xPos, _yPos];
	cursorSprite = _cursorSprite;
}