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