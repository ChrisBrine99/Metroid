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